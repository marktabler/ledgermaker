class Ledger < ActiveRecord::Base
  attr_accessible :title
  has_many :transactions

  def opening_balance
    transactions.first.value
  end

  def opening_balance=(amount)
    if transactions.any?
      
    transactions.create
  end

  def current_balance
    transactions.current.sum('value')
  end

  def projected_balance
    current_balance + transactions.projected.sum('value')
  end
end
