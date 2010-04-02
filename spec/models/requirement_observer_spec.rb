require "spec_helper"

describe RequirementObserver do
  subject {RequirementObserver.instance}

  before(:each) do
    @req = mock_model(Requirement)
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
