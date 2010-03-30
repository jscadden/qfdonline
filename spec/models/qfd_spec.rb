require 'spec_helper'

describe Qfd do
  before(:each) do
    @qfd = Factory.build("qfd")
  end

  describe "Factory" do
    it "should create a new instance" do
      @qfd.save!
    end
  end

  describe "#name" do
    it "should be required" do
      @qfd.name = nil

      @qfd.save.should be_false
      @qfd.errors.on("name").should_not be_empty
    end
  end
end
