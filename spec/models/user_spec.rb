require 'spec_helper'

describe User do
  let(:user) { Fabricate(:user) }

  it "has a working factory" do
    Fabricate(:user)
  end
end
