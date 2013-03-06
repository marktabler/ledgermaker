class Ledger < ActiveRecord::Base
  attr_accessible :title
  has_many :transactions

  def opening_balance
    transactions.first.value
  end

  def opening_balance=(amount)
    if transactions.any?
      transactions.first.update_attributes(value: amount)
    else
      transactions.create(title: "Opening Balance", value: amount)
    end
  end

  def current_balance
    transactions.current.sum('value')
  end

  def projected_balance(through = nil)
    current_balance + transactions.projected(through).sum('value')
  end
end
