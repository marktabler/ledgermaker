class Ledger < ActiveRecord::Base
  attr_accessible :title
  has_many :transactions

  def current_balance
    transactions.current.sum('value_in_cents') / 100.0
  end

  def last_transaction
    transactions.order(:date).last
  end

  def projected_balance(through = nil)
    through ||= last_transaction.date
    current_balance + transactions.on_or_after(through).sum('value_in_cents') / 100.0
  end

  def balance_by_day(from, through)

  end

  def transaction_dates
    transactions.order(:date).pluck(:date).uniq
  end
end
