require "spec_helper"

describe Ledger do
  it "has a working factory" do
    Fabricate(:ledger).should be_a Ledger
  end

end