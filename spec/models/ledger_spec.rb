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

  let(:projected_transactions) do
    values = [55, 11]
    values.map do |value|
      Fabricate(:transaction, ledger: @ledger, value_in_cents: value,
                 date: Date.today)
    end
  end

  let(:current_transactions) do
    values = [100, 500, 1000, 2000, -50]
    values.map do |value|
      Fabricate(:transaction, ledger: @ledger, value_in_cents: value,
                 date: Date.today - 1.days)
    end
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
    values = current_transactions.map(&:value_in_cents)
    @ledger.current_balance.should == (values.inject(&:+) / 100.0)
  end

  it "calculates its projected balance" do
    values = current_transactions.map(&:value_in_cents)
    projected_values = projected_transactions.map(&:value_in_cents)
    all_values = values + projected_values
    @ledger.projected_balance.should == (all_values.inject(&:+) / 100.0)
  end

  it "finds unique dates of transactions" do
    2.times do
      projected_transactions.map { |t| t.recur(:month, 1) }
      current_transactions.map { |t| t.recur(:month, 1) }
    end
    expected_dates = ["May 26, 2012", "May 27, 2012",
        "June 26, 2012", "June 27, 2012"].map { |d| Date.parse(d) } 
    @ledger.transaction_dates.should == expected_dates
  end

  it "calculates its balance by date" do
    dates = (current_transactions + projected_transactions).map(&:date)
    @ledger.balance_by_date.keys.should == dates.uniq
    @ledger.balance_by_date[dates.first].should == @ledger.projected_balance(dates.first)
    @ledger.balance_by_date[dates.last].should == @ledger.projected_balance(dates.last)
  end

  it "can update a subscription in batch" do
    projected_transactions.first.recur(:month, 5)
    stable_value = projected_transactions.last.value
    @ledger.update_subscription(projected_transactions.first, value: 887.50)
    Transaction.where(title: projected_transactions.first.title).pluck(:value_in_cents).uniq.should == [88750]
    projected_transactions.last.value.should == stable_value
  end
end