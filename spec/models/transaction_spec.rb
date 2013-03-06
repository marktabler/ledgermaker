require "spec_helper"

describe Transaction do
  it "has a working factory" do
    Fabricate(:transaction).should be_a Transaction
  end

  it "translates from value to value_in_cents" do
    t = Fabricate(:transaction)
    t.value = 123.45
    t.value_in_cents.should == 12345
  end

  it "translates from value_in_cents to value" do
    t = Fabricate(:transaction)
    t.value_in_cents = 45678
    t.value.should == 456.78
  end

  it "can recur monthly" do
    t = Fabricate(:transaction)
    t.recur_monthly(3)
    Transaction.count.should == 4
    Transaction.last.ledger_id.should == t.ledger_id
    Transaction.last.date.should == DateTime.parse("August 28, 2012")
  end

  it "can recur weekly" do
    t = Fabricate(:transaction)
    t.recur_weekly(8)
    Transaction.count.should == 9
    Transaction.last.ledger_id.should == t.ledger_id
    Transaction.last.date.should == DateTime.parse("July 23, 2012")
  end

  it "can express a simple (formatted) date" do
    t = Fabricate(:transaction)
    t.simple_date.should == "05/28/12"
  end
end