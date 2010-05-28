require 'spec_helper'

describe HoqListObserver do
  subject {HoqListObserver.instance}

  before(:each) do
    hoqs = mock_model(Array, :new => mock_model(Hoq))
    @hoq_list = mock_model(HoqList, :hoqs => hoqs)
  end

  it "should create an example HOQ" do
    @hoq_list.should_receive(:insert_front)

    subject.after_create(@hoq_list)
  end
end
