class Transaction < ActiveRecord::Base
  attr_accessible :date, :title, :value, :ledger_id, :value_in_cents

  belongs_to :ledger

  # Yes, this is correct. When a company offers to "credit" your account,
  # they're talking about the transaction from their perspective, not yours.
  scope :debit, where("value_in_cents >= 0")
  scope :credit, where("value_in_cents < 0")
  
  scope :current, lambda { where("date <= ?", DateTime.now.end_of_day) }
  scope :projected, lambda { |projection_date = nil|
    if projection_date
      where("date > ? and date <= ?", DateTime.now.end_of_day, projection_date) 
    else
      where("date > ?", DateTime.now.end_of_day) 
    end
  }

  def credit?
    value_in_cents < 0
  end

  def debit?
    !credit?
  end

  def value
    (value_in_cents / 100.0).round(2)
  end

  def value=(amount)
    update_attributes(value_in_cents: (amount * 100).to_i)
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

  protected

  def generate_recurrence(period)
    Transaction.create!(ledger_id: ledger_id, 
                        title: title, 
                        value_in_cents: value_in_cents, 
                        date: calculated_date(period))
  end

  def calculated_date(period)
    case period
    when :month
      date + 1.month
    when :week
      date + 1.week
    when :biweek
      date + 2.weeks
    end
  end

end
