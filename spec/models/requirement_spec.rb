require 'spec_helper'

describe Requirement do
  before(:each) do
    @req = Factory.build("requirement")
  end

  it "should create a new instance given valid attributes" do
    @req.save!
  end
end
