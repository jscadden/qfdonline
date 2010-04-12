require "spec_helper"

describe RatingObserver do
  subject {RatingObserver.instance}

  before(:each) do
    @rating = mock_model(Rating)
  end

  describe "#after_save" do
    context "on value change" do
      before(:each) do
        @rating.stub(:value_changed?).and_return(true)
      end

      it "should notify its secondary requirement" do
        req = mock_model(Requirement)
        req.should_receive(:secondary_rating_changed)
        @rating.stub(:secondary_requirement).and_return(req)

        subject.after_save(@rating)
      end
    end
  end

  describe "#after_destroy" do
    it "should notify its secondary requirement" do
      req = mock_model(Requirement)
      req.should_receive(:secondary_rating_changed)
      @rating.stub(:secondary_requirement).and_return(req)

      subject.after_destroy(@rating)
    end
  end

end
