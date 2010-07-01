require 'spec_helper'

describe HoqsController do

  before(:each) do
    activate_authlogic
  end

  context("guest") do

    before(:each) do
      logout
      login_as_guest
    end

    [:new, :create,].each do |action|
      describe("##{action}") do

        before(:each) do
          collection_setup
          @hoq = mock_model(Hoq, :qfd => @qfd)
          @qfd.stub_chain(:hoq_list, :hoqs, :build => @hoq)
        end

        context("any qfd") do
          it "should be denied" do
            send("do_#{action}")

            response.should be_permission_denied, response.status
          end
        end
      end
    end

    [:destroy, :update,].each do |action|
      describe("##{action}") do

        before(:each) do
          member_setup
        end

        context("any qfd") do
          it "should be denied" do
            send("do_#{action}")

            response.should be_permission_denied, response.status
          end
        end
      end
    end
  end

  describe "#show" do
    before(:each) do
      member_setup
      bypass_authorization
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
      bypass_authorization
      collection_setup
      login
      @hoq = mock_model(Hoq)
      @qfd.stub_chain(:hoq_list, :hoqs, :build => @hoq)
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
      bypass_authorization
      collection_setup
      login
      @hoq = mock_model(Hoq)
      @qfd.stub_chain(:hoq_list, :hoqs, :build => @hoq)
    end

    context "when successful" do

      before(:each) do
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
    Qfd.stub(:find).and_return(@qfd)
    subject.stub(:new_controller_object_for_collection).and_return(@qfd)
  end

  def member_setup
    collection_setup

    @hoq_list = mock_model(HoqList, :qfd => @qfd)
    @hoq = mock_model(Hoq, :qfd => @qfd, :hoq_list => @hoq_list)
    Hoq.stub(:find).and_return(@hoq)
  end

  def do_new(params={})
    get :new, {}.merge(params)
  end

  def do_create(params={})
    post :create, {:hoq => {:name => "Test HOQ"}}.merge(params)
  end

  def do_destroy(params={})
    post :destroy, {:id => "1"}.merge(params)
  end

  def do_update(params={})
    post :update, {:hoq => {:name => "Updated Test HOQ"}}.merge(params)
  end

  def bypass_authorization
    subject.stub(:filter_access_filter).and_return(true)
  end
end
