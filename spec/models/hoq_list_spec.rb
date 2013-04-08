require 'spec_helper'

describe HoqList do
  before(:each) do
    @hoq_list = Factory.create("hoq_list")
    fail "no hoqs found" unless @hoq_list.hoqs.count == 1
  end

  it "should create a new instance given valid attributes" do
    @hoq_list.should_not be_new_record
  end

  it "should create a HOQ after creating itself" do
    @hoq_list.should have(1).hoq
  end

  def it_should_change_the_size_of_the_hoq_list_by_1(&block)
    lambda {block.call}.should change(@hoq_list.hoqs, :count).by(1)
  end

  describe "successful front and back inserts", :shared => true do
    describe "#insert_back" do
      it "should find the new HOQ in the last position" do
        @hoq_list.insert_back(@hoq)
        @hoq_list.hoqs.at(@hoq_list.hoqs.size).should == @hoq
      end
    end

    describe "#insert_front" do
      it "should find the new HOQ in the first position" do
        @hoq_list.insert_front(@hoq)
        @hoq_list.hoqs.at(1).should == @hoq
      end
    end
  end

  describe "a successful insert at pos 1", :shared => true do
    it "pos 1 should find the new HOQ in pos 1" do
      @hoq_list.insert_at(@hoq, 1)
      @hoq_list.hoqs.at(1).should == @hoq
    end
  end

  describe "a failed insert when pos < 1", :shared => true do
    it "pos -1 should raise IndexError" do 
      lambda {@hoq_list.insert_at(@hoq, -1)}.should raise_error IndexError
    end

    it "pos 0 should raise IndexError" do 
      lambda {@hoq_list.insert_at(@hoq, 0)}.should raise_error IndexError
    end
  end

  context "basics" do

    before(:each) do
      @hoq = Factory.build("hoq")
    end

    describe "#insert_back" do
      it "should change the size of the hoq list by 1" do
        it_should_change_the_size_of_the_hoq_list_by_1 do
          @hoq_list.insert_back(@hoq)
        end
      end
    end

    describe "#insert_front" do
      it "should change the size of the hoq list by 1" do
        it_should_change_the_size_of_the_hoq_list_by_1 do
          @hoq_list.insert_front(@hoq)
        end
      end
    end

    describe "#insert_at" do
      it_should_behave_like "a failed insert when pos < 1"

      it "should change the size of the hoq list by 1" do
        it_should_change_the_size_of_the_hoq_list_by_1 do
          @hoq_list.insert_at(@hoq, 1)
        end
      end
    end
  end

  context "size 0" do
    before(:each) do 
      @hoq_list.hoqs.clear
      fail "HoqList setup failed" if @hoq_list.new_record?
      fail "HoqList is not empty" unless @hoq_list.hoqs.empty?
      @hoq = Factory.build("hoq")
    end

    describe("#insert_at") do
      it_should_behave_like "a successful insert at pos 1"

      it "pos 1 should have a new primary requirements list" do
        RequirementsList.should_receive(:create!).twice
        @hoq_list.insert_at(@hoq, 1)
      end

      it "pos 1 should have a new secondary requirements list" do
        RequirementsList.should_receive(:create!).twice
        @hoq_list.insert_at(@hoq, 1)
      end

      it "pos 2 should raise IndexError" do
        lambda {@hoq_list.insert_at(@hoq, 2)}.should raise_error IndexError
      end
    end

    it_should_behave_like "successful front and back inserts"
  end

  context "size 2" do
    before(:each) do
      fail "HoqList setup failed" if @hoq_list.new_record?
      @hoq_list.insert_back(Factory.build("hoq", :name => "HOQ #1"))
      fail "HoqList is not size 2" unless 2 == @hoq_list.hoqs.size
      fail "HoqList is not size 2" unless 2 == @hoq_list.hoqs.count
      @hoq = Factory.build("hoq")
      fail "size/count mismatch" unless @hoq_list.hoqs.count == @hoq_list.hoqs.size
      fail "HoqList is not size 2" unless @hoq_list.hoqs.count == 2
    end

    describe("#insert_at") do
      it "pos 1 should find the new HOQ in pos 1" do
        fail "size/count mismatch" unless @hoq_list.hoqs.count == @hoq_list.hoqs.size
        fail "HoqList is not size 2" unless @hoq_list.hoqs.count == 2
        @hoq_list.insert_at(@hoq, 1)
        @hoq_list.hoqs.at(1).should == @hoq
      end

      it "pos 1 should have a new primary requirements list" do
        fail "size/count mismatch" unless @hoq_list.hoqs.count == @hoq_list.hoqs.size
        fail "HoqList is not size 2" unless @hoq_list.hoqs.count == 2
        RequirementsList.should_receive(:create!)
        @hoq_list.insert_at(@hoq, 1)
      end

      it "pos 1 should not have a new secondary requirements list" do
        fail "size/count mismatch" unless @hoq_list.hoqs.count == @hoq_list.hoqs.size
        fail "HoqList is not size 2" unless @hoq_list.hoqs.count == 2
        @hoq.should_not_receive(:build_secondary_requirements_list)
        @hoq_list.insert_at(@hoq, 1)
      end

      it "pos 2 should find the new HOQ in pos 2" do
        fail "size/count mismatch" unless @hoq_list.hoqs.count == @hoq_list.hoqs.size
        fail "HoqList is not size 2" unless @hoq_list.hoqs.count == 2
        @hoq_list.insert_at(@hoq, 2)
        @hoq_list.hoqs.at(2).should == @hoq
      end

      it "pos 2 should not have a new primary requirements list" do
        fail "size/count mismatch" unless @hoq_list.hoqs.count == @hoq_list.hoqs.size
        fail "HoqList is not size 2" unless @hoq_list.hoqs.count == 2
        @hoq.should_not_receive(:build_primary_requirements_list)
        @hoq_list.insert_at(@hoq, 2)
      end

      it "pos 2 should not have a new secondary requirements list" do
        fail "size/count mismatch" unless @hoq_list.hoqs.count == @hoq_list.hoqs.size
        fail "HoqList is not size 2" unless @hoq_list.hoqs.count == 2
        @hoq.should_not_receive(:build_secondary_requirements_list)
        @hoq_list.insert_at(@hoq, 2)
      end

      it "pos 3 should find the new HOQ in pos 3" do
        fail "size/count mismatch" unless @hoq_list.hoqs.count == @hoq_list.hoqs.size
        fail "HoqList is not size 2" unless @hoq_list.hoqs.count == 2
        @hoq_list.insert_at(@hoq, 3)
        @hoq_list.hoqs.at(3).should == @hoq
      end

      it "pos 3 should not have a new primary requirements list" do
        fail "size/count mismatch" unless @hoq_list.hoqs.count == @hoq_list.hoqs.size
        fail "HoqList is not size 2" unless @hoq_list.hoqs.count == 2
        @hoq.should_not_receive(:build_primary_requirements_list)
        @hoq_list.insert_at(@hoq, 3)
      end

      it "pos 3 should have a new secondary requirements list" do
        fail "size/count mismatch" unless @hoq_list.hoqs.count == @hoq_list.hoqs.size
        fail "HoqList is not size 2" unless @hoq_list.hoqs.count == 2
        RequirementsList.should_receive(:create!)
        @hoq_list.insert_at(@hoq, 3)
      end

      it "pos 4 should raise IndexError" do
        fail "size/count mismatch" unless @hoq_list.hoqs.count == @hoq_list.hoqs.size
        fail "HoqList is not size 2" unless @hoq_list.hoqs.count == 2
        lambda {@hoq_list.insert_at(@hoq, 4)}.should raise_error IndexError
      end
    end

    it_should_behave_like "successful front and back inserts"
  end

end
