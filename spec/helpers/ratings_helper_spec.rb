require 'spec_helper'

describe RatingsHelper do

  describe "#number_to_relative_weight" do
    it "should return two decimal places" do
      helper.number_to_relative_weight(55.55555555).should match /\d+\.\d{2}/
    end
  end

end
