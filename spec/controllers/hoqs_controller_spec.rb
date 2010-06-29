require 'spec_helper'

describe HoqsController do

  before(:each) do
    activate_authlogic
  end

  describe "#show" do
    before(:each) do
      member_setup
    end

    it "should assign @hoq" do
      get :show

      assigns[:hoq].should == @hoq
    end

    it "should assign @qfd" do
      get :show

      assigns[:qfd].should == @qfd
    end
  end

  describe "#new" do
    before(:each) do
      member_setup
      login
      @qfd.stub_chain(:hoqs, :build => @hoq)
    end

    it "should assign @hoq" do
      get :new

      assigns[:hoq].should == @hoq
    end

    it "should assign @qfd" do
      get :new

      assigns[:qfd].should == @qfd
    end

    it "should render the new action" do
      get :new
      
      response.should render_template("new")
    end
  end

  describe "#create" do
    before(:each) do 
      collection_setup
      login
    end

    context "when successful" do

      before(:each) do
        @hoq = mock_model(Hoq)
        @qfd.stub_chain(:hoqs, :build => @hoq)
        @qfd.stub_chain(:hoq_list, :insert_back => true)
      end

      it "should redirect to the new hoq" do
        post :create

        response.should redirect_to(qfd_hoq_path(@qfd, @hoq))
      end

      it "should set a flash notice" do
        post :create

        flash[:notice].should_not be_blank
      end

    end

    context "when unsuccessful" do
      before(:each) do
        @hoq = mock_model(Hoq)
        @qfd.stub_chain(:hoqs, :build => @hoq)
        @qfd.stub_chain(:hoq_list, :insert_back => false)
      end

      it "should render the new template" do
        post :create

        response.should render_template("new")
      end

    end
  end


  private

  def collection_setup
    @qfd = mock_model(Qfd)
    Qfd.stub_chain(:with_permissions_to, :find => @qfd)
  end

  def member_setup
    collection_setup

    @hoq = mock_model(Hoq, :qfd => @qfd)
    @qfd.stub_chain(:hoqs, :find => @hoq)
  end
end
