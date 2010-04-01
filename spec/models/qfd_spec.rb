require 'spec_helper'

describe Qfd do
  before(:each) do
    @qfd = Factory.build("qfd")
  end

  it "should create a new instance given valid attributes" do
    @qfd.save!
  end

  describe "after creation" do
    it "should create a HoqList" do
      @qfd.save!
      @qfd.hoq_list.should_not be_nil
    end
  end
end
