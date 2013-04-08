require 'spec_helper'

describe QfdObserver do

  before(:each) do
    Authorization.ignore_access_control(true) 
    @qfd = Factory.build("qfd")
  end

  describe "#after create" do
    it "should create a HoqList" do
      Factory("qfd").hoq_list.should_not be_nil
    end
  end

end
