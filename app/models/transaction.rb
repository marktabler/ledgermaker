class Transaction < ActiveRecord::Base

  attr_accessible :date, :title, :value, :ledger_id, :value_in_cents
  attr_accessor :recurrence_period, :number_of_recurrences
  attr_accessible :recurrence_period, :number_of_recurrences
  validates :date, presence: true
  belongs_to :ledger

  default_scope order('date ASC')

  # Yes, this is correct. When a company offers to "credit" your account,
  # they're talking about the transaction from their perspective, not yours.
  scope :debit, where("value_in_cents >= 0")
  scope :credit, where("value_in_cents < 0")
  

  scope :between, lambda {|from, to| where("date >= ? AND date <= ?", from, to)}
  scope :before, lambda { |target_date| where("date < ?", target_date) }
  scope :through, lambda { |target_date| where("date <= ?", target_date) }
  scope :on_or_after, lambda { |target_date| where("date >= ?", target_date) }

  def self.current
    before(Date.today)
  end

  def self.projected
    on_or_after(Date.today)
  end

  def self.create_and_recur(params)
    transaction = self.create!(params)
    transaction.save
    if transaction.recurrence_period
      transaction.recur(transaction.recurrence_period, 
                        transaction.number_of_recurrences.to_i)
    end    
  end

  def credit?
    value_in_cents < 0
  end

  def debit?
    !credit?
  end

  def value
    ((value_in_cents || 0 ) / 100.0).round(2)
  end

  def value=(amount)
    update_attributes(value_in_cents: (amount.to_f * 100).to_i)
  end
  
  def recur(period, number_of_periods)
    transaction = self
    number_of_periods.times do 
      transaction = transaction.generate_recurrence(period)
    end
  end

  def recur_biweekly(number_of_periods = 1)
    recur(:biweek, number_of_periods)
  end

  def recur_weekly(number_of_periods = 1)
    recur(:week, number_of_periods)
  end

  def recur_monthly(number_of_periods = 1)
    recur(:month, number_of_periods)
  end

  def simple_date
    date.strftime("%D")
  end

  def cancel_recurrence
    forward_transactions = Transaction.where(
      "title = ? AND date >= ?", self.title, self.date
      )
    forward_transactions.destroy_all
  end

  protected

  def generate_recurrence(period)
    Transaction.create!(
      ledger_id: ledger_id, 
      title: title, 
      value_in_cents: value_in_cents, 
      date: calculated_recurrence_date(period)
    )
  end

  def calculated_recurrence_date(period)
    case period.to_sym
    when :month
      date + 1.month
    when :week
      date + 1.week
    when :biweek
      date + 2.weeks
    end
  end

end
