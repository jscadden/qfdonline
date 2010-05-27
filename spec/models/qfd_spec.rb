require 'spec_helper'

describe Qfd do
  before(:each) do
    Authorization.ignore_access_control(true) 
    @qfd = Factory.build("qfd")
  end

  after(:each) do
    Authorization.ignore_access_control(false) 
  end

  it "should create a new instance given valid attributes" do
    @qfd.save!
  end

  describe "after creation" do
    it "should create a HoqList" do
      @qfd.save!
      @qfd.hoq_list.should_not be_nil
    end
  end

  context "Authorization" do
    before(:each) do
      @invites = [mock_model(Invitation).as_null_object,]
      @owner = Factory.build("user")
      @qfd = Factory.create("qfd", :user => @owner, :invitations => @invites)
      @user = Factory.build("user", :login => "funk", :email => "as@df.com")
      Authorization.ignore_access_control(false) 
    end

    it "should not allow a third-party to update it" do
      with_user(@user) do
        should_not_be_allowed_to(:update, @qfd)
      end
    end

    it "should allow a collaborator to update it" do
      @user.stub(:invitations_received).and_return(@invites)

      with_user(@user) do
        should_be_allowed_to(:update, @qfd)
      end
    end

    it "should allow a its user to update it" do
      with_user(@owner) do
        should_be_allowed_to(:update, @qfd)
      end
    end

  end
end
