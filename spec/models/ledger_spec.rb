require "spec_helper"

describe Ledger do

  before(:all) do
    Timecop.freeze(DateTime.parse("May 28, 2012"))
  end

  after(:all) do
    Timecop.return
  end

  before(:each) do
    @ledger = Fabricate(:ledger)
  end

  it "has a working factory" do
    @ledger.should be_a Ledger
  end

  it "should accept opening balance as an assignment" do
    pending "Need to decide how to set the date of the opening transaction"
  end

  it "should retrieve opening balance from the first transaction" do
    pending "Need to decide how to set the date of the opening transaction"
  end

  it "calculates its current balance" do
    values = [100, 500, 1000, 2000, -50]
    values.each do |value|
      Fabricate(:transaction, ledger: @ledger, value_in_cents: value)
    end
    projected_values = [55, 11]
    projected_values.each do |value|
      Fabricate(:transaction, ledger: @ledger, value_in_cents: value,
                 date: DateTime.now + 1.days)
    end
    @ledger.current_balance.should == (values.inject(&:+) / 100.0)
  end

  it "calculates is projected balance" do
    values = [100, 500, 1000, 2000, -50]
    values.each do |value|
      Fabricate(:transaction, ledger: @ledger, value_in_cents: value)
    end
    projected_values = [55, 11]
    projected_values.each do |value|
      Fabricate(:transaction, ledger: @ledger, value_in_cents: value,
                 date: DateTime.now + 1.days)
    end
    all_values = values + projected_values
    @ledger.projected_balance.should == (all_values.inject(&:+) / 100.0)
  end
end