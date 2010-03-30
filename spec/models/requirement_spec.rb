require 'spec_helper'

describe Requirement do
  before(:each) do
    @requirement = Factory.build("requirement")
  end

  describe "Factory" do
    it "should create a new instance" do
      @requirement.save!
    end
  end

  describe "#name" do
    it "should be required" do
      @requirement.name = nil

      @requirement.save.should be_false
      @requirement.errors.on("name").should_not be_empty
    end
  end
end
