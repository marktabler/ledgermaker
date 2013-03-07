class Ledger < ActiveRecord::Base
  attr_accessible :title
  has_many :transactions

  def current_balance
    transactions.current.sum('value_in_cents') / 100.0
  end

  def projected_balance(through = nil)
    current_balance + transactions.projected(through).sum('value_in_cents') / 100.0
  end

  def balance_by_day(from, through)

  end

  def transaction_dates
    transactions.order(:date).pluck(:date).uniq
  end
end
