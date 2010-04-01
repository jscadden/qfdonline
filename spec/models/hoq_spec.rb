require 'spec_helper'

describe Hoq do
  before(:each) do
    @hoq = Factory.build("hoq")
  end

  it "should create a new instance given valid attributes" do
    @hoq.save!
  end
end
