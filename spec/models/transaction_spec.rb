require "spec_helper"

describe Transaction do
  
  before(:all) do
    Timecop.freeze(DateTime.parse("May 28, 2012"))
  end

  after(:all) do
    Timecop.return
  end

  let(:transaction) do
    Fabricate(:transaction)
  end

  it "has a working factory" do
    transaction.should be_a Transaction
  end

  it "translates from value to value_in_cents" do
    transaction.value = 123.45
    transaction.value_in_cents.should == 12345
  end

  it "translates from value_in_cents to value" do
    transaction.value_in_cents = 45678
    transaction.value.should == 456.78
  end

  it "can recur monthly" do
    transaction.recur_monthly(3)
    Transaction.count.should == 4
    Transaction.last.ledger_id.should == transaction.ledger_id
    Transaction.last.date.should == DateTime.parse("August 28, 2012")
  end

  it "can recur weekly" do
    transaction.recur_weekly(8)
    Transaction.count.should == 9
    Transaction.last.ledger_id.should == transaction.ledger_id
    Transaction.last.date.should == DateTime.parse("July 23, 2012")
  end

  it "can recur biweekly" do
    transaction.recur_biweekly(2)
    Transaction.count.should == 3
    Transaction.last.ledger_id.should == transaction.ledger_id
    Transaction.last.date.should == DateTime.parse("June 25, 2012")
  end

  it "can cancel recurrence" do
    transaction.recur_weekly(14)
    middle_transaction = Transaction.order(:date).all[8]
    middle_transaction.cancel_recurrence
    Transaction.last.date.should == DateTime.parse("July 16, 2012")
    Transaction.count.should == 8
  end

  it "can express a simple (formatted) date" do
    transaction.simple_date.should == "05/28/12"
  end

  it "can scope to all projected transactions" do
    transaction.recur_weekly(5)
    transaction.update_attributes(date: Date.today - 3.days)
    Transaction.projected.count.should == 5
  end

  # This will generate 6 transactions.
  # The 5th and 6th transactions get cut off by selecting the date of the 4th.
  # The 4th doesn't count because we're cutting off the day before.
  # That leaves 3 transactions to show up.
  it "can scope to projected transactions up through a certain date" do
    transaction.recur_weekly(5)
    fourth_transaction = Transaction.order(:date).all[3]
    Transaction.on_or_after(fourth_transaction.date - 1.day).count.should == 3
  end

  it "identifies credits" do
    transaction.value = -50
    transaction.credit?.should be_true
    Transaction.credit.count.should == 1
  end

  it "identifies debits" do
    transaction.value = 50
    transaction.debit?.should be_true
    Transaction.debit.count.should == 1
  end
end