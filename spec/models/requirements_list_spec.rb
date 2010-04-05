require "spec_helper"

describe RequirementsList do

  describe "#recalc_relative_weights" do
    before(:each) do
      @reqs = (1..3).map {mock_model(Requirement)}
      subject.requirements = @reqs
    end

    it "should tell its requirements to update their relative weights" do
      @reqs.each {|x| x.should_receive(:recalc_relative_weight)}
      
      subject.send(:recalc_relative_weights)
    end
  end

end
