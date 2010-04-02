require 'spec_helper'

describe Requirement do
  subject {Factory.build("requirement")}

  it "should create a new instance given valid attributes" do
    subject.save!
  end

  describe "#relative_weight" do
    context "validation" do
      it "should reject \"junk\"" do
        subject.relative_weight = "junk"

        subject.should_not be_valid
        subject.errors.on(:relative_weight).should_not be_empty
      end

      it "should accept 0" do
        subject.relative_weight = 0

        subject.should be_valid
      end

      it "should accept 1.5" do
        subject.relative_weight = 1.5

        subject.should be_valid
      end

      it "should reject 1,000.5" do
        subject.relative_weight = "1,000.5"

        subject.should_not be_valid
        subject.errors.on(:relative_weight).should_not be_empty
      end

      it "should accept \"0\"" do
        subject.relative_weight = "0"

        subject.should be_valid
      end

      it "should accept \"1.5\"" do
        subject.relative_weight = "1.5"

        subject.should be_valid
      end
    end
  end

  describe "#weight" do

    context "validation" do
      it "should reject \"junk\"" do
        subject.weight = "junk"

        subject.should_not be_valid
        subject.errors.on(:weight).should_not be_empty
      end

      it "should accept 0" do
        subject.weight = 0

        subject.should be_valid
      end

      it "should accept 1.5" do
        subject.weight = 1.5

        subject.should be_valid
      end

      it "should reject 1,000.5" do
        subject.weight = "1,000.5"

        subject.should_not be_valid
        subject.errors.on(:weight).should_not be_empty
      end

      it "should accept \"0\"" do
        subject.weight = "0"

        subject.should be_valid
      end

      it "should accept \"1.5\"" do
        subject.weight = "1.5"

        subject.should be_valid
      end
    end
  end

end
