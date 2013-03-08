class Ledger < ActiveRecord::Base
  attr_accessible :title
  has_many :transactions

  def current_balance
    transactions.current.sum('value_in_cents') / 100.0
  end

  def subscription_for(transaction)
    transactions.where(title: transaction.title)
  end

  def update_subscription(transaction, attrs)
    subscription_for(transaction).each do |t|
      t.update_attributes(attrs)
    end
  end

  def projected_balance(through = nil)
    through ||= transactions.last.date
    transactions.through(through).sum('value_in_cents') / 100.0
  end

  def balance_by_date(range = {})
    balances = Hash.new
    transaction_dates(range).each do |date|
      balances[date] = projected_balance(date)
    end
    balances
  end

  def transaction_dates(range = {})
    range[:from] ||= transactions.first.date
    range[:to] ||= transactions.last.date
    transactions.between(range[:from], range[:to]).pluck(:date).uniq
  end
end
