describe "HoqListExtensions" do

  before(:each) do
    @list = HoqList.create
    fail "Failed to save HoqList" if @list.new_record?
  end

  describe "#at" do
    it "should raise IndexError when no HOQ is found" do
      lambda {@list.hoqs.at(13)}.should raise_error(IndexError)
    end

    it "should find the hoq in position 1" do
      first_hoq = Factory.build("hoq", :hoq_list_id => @list.id)
      @list.insert_front(first_hoq)

      @list.hoqs.at(1).should == first_hoq
    end

    it "should find the hoq in position 2" do
      fail "list doesn't have example hoq" if @list.hoqs.empty?
      second_hoq = Factory.build("hoq")
      @list.insert_back(second_hoq)

      @list.hoqs.at(2).should == second_hoq
    end
  end

end
