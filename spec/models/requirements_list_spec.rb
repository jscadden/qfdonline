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

  describe "#sort" do
    context("weight asc") do
      before(:each) do
        @req_high_weight = mock_model(Requirement, :weight => 10)
        @req_low_weight = mock_model(Requirement, :weight => 8)
      end

      it "should sort the higher weighted requirement to the end" do
        Requirement.stub(:find).and_return([@req_low_weight, @req_high_weight])
        @req_high_weight.should_receive(:update_attribute).with(:position, 2)
        @req_low_weight.should_receive(:update_attribute).with(:position, 1)

        subject.sort(:weight)
      end

      it "should sort the lower weighted requirement to the end" do
        Requirement.stub(:find).and_return([@req_high_weight, @req_low_weight])
        @req_high_weight.should_receive(:update_attribute).with(:position, 1)
        @req_low_weight.should_receive(:update_attribute).with(:position, 2)

        subject.sort(:weight)
      end
    end

    context("bad_column") do
      it "should raise an ArgumentError" do
        lambda do
          subject.sort(:bad_column)
        end.should raise_error ArgumentError, /invalid sort attribute/
      end
    end
  end
end
