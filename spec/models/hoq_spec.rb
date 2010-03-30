require 'spec_helper'

describe Hoq do
  before(:each) do
    @hoq = Factory.build("hoq")
  end

  describe "Factory" do
    it "should create a new instance" do
      @hoq.save!
    end
  end

  describe "#name" do
    it "should be required" do
      @hoq.name = nil

      @hoq.save.should be_false
      @hoq.errors.on("name").should_not be_empty
    end
  end
end
