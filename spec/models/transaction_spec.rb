require "spec_helper"

describe Transaction do
  it "has a working factory" do
    Fabricate(:transaction).should be_a Transaction
  end
end