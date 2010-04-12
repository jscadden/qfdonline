require "spec_helper"

describe RequirementObserver do
  subject {RequirementObserver.instance}

  before(:each) do
    @req = stub_model(Requirement)
  end

  describe "#after_create" do 
    context "when position 3 is requested" do
      before(:each) do
        @req.stub(:requested_position).and_return(3)
      end

      it "should move the requirement into position" do
        @req.should_receive(:insert_at).with(3)

        subject.after_create(@req)
      end
    end

    context "when no position requested" do
      it "should not move the requirement" do
        @req.stub(:requested_position).and_return(nil)
        @req.should_not_receive(:insert_at)

        subject.after_create(@req)
      end
    end
  end

  describe "#after_save" do
    context "on weight change" do
      before(:each) do
        @req.stub(:weight_changed?).and_return(true)
      end

      it "should notify its requirements list" do
        list = mock_model(RequirementsList)
        list.should_receive(:requirement_weight_changed)
        @req.stub(:requirements_list).and_return(list)

        subject.after_save(@req)
      end
    end
  end
end
