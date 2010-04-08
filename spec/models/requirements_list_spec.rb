require "spec_helper"

describe RequirementsList do

  describe "#recalc_relative_weights" do
    before(:each) do
      @reqs = (1..3).map {mock_model(Requirement)}
      subject.requirements = @reqs
    end

    context("total of weights is 0") do
      it "should not tell its requirements to update their relative weights" do
        @reqs.each {|x| x.should_not_receive(:recalc_relative_weight)}
        
        subject.send(:recalc_relative_weights)
      end
    end

    context("total of weights is > 0") do
      before(:each) do
        subject.requirements.stub(:sum).and_return(3)
      end

      it "should tell its requirements to update their relative weights" do
        @reqs.each {|x| x.should_receive(:recalc_relative_weight)}
        
        subject.send(:recalc_relative_weights)
      end
    end
  end

end
