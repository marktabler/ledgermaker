class Transaction < ActiveRecord::Base
  attr_accessible :date, :title, :value, :ledger_id, :value_in_cents

  belongs_to :ledger

  scope :current, lambda { where("date <= ?", DateTime.now.end_of_day) }
  scope :projected, lambda { where("date > ?", DateTime.now.end_of_day) }

  def value
    (value_in_cents / 100.0).round(2)
  end

  def value=(amount)
    update_attributes(value_in_cents: (amount * 100).to_i)
  end

  def recur_weekly(number_of_weeks = 1)
    transaction = self
    number_of_weeks.times do 
      transaction = transaction.recur(:week)
    end
  end

  def recur_monthly(number_of_months = 1)
    transaction = self
    number_of_months.times do 
      transaction = transaction.recur(:month)
    end
  end

  def simple_date
    date.strftime("%D")
  end

  private

  def recur(period = :month)
    calculated_date = (period == :month ? date + 1.month : date + 1.week)
    Transaction.create(ledger_id: ledger_id, title: title, 
                       value_in_cents: value_in_cents, date: calculated_date)
  end

end
