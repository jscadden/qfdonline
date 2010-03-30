require 'spec_helper'

describe Hoq do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :qfd_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Hoq.create!(@valid_attributes)
  end
end
