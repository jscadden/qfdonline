require 'spec_helper'

describe Qfd do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :user_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Qfd.create!(@valid_attributes)
  end
end
