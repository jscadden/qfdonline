require 'spec_helper'

describe Rating do
  before(:each) do
    @rating = Factory.build("rating")
    disable_observers_for(@rating)
  end

  it "should create a new instance given valid attributes" do
    @rating.save!
  end

  describe("#value") do
    context("validations") do
      [4, "7",].each do |x|
        it "should reject #{x.inspect}" do
          @rating.value = x
        
          @rating.should_not be_valid
          @rating.errors.on(:value).should_not be_empty
        end
      end

      [1, 3, 9, "3",].each do |x|
        it "should accept #{x.inspect}" do
          @rating.value = x
        
          @rating.should be_valid
        end
      end
    end
  end
end
