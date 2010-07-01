require 'spec_helper'

describe RequirementsController do

  context "guests" do

    before(:each) do
      logout
      login_as_guest
      Requirement.stub(:find).and_return(mock_model(Requirement))
    end

    [:create, :destroy, :update,].each do |action|
      describe("##{action}") do
        context("a public qfd") do
          it "should deny access" do
            do_update

            response.should be_permission_denied
          end
        end

        context("a private qfd") do
          it "should deny access" do
            do_update

            response.should be_permission_denied
          end
        end
      end
    end
  end

  context "user" do

    before(:each) do
      logout
      login
      requirement = mock_model(Requirement, :update_attributes => true)
      qfd = mock_model(Qfd)
      requirement.stub_chain(:requirements_list, :primary_hoq, :hoq_list, :qfd).and_return(qfd)
      Requirement.stub(:find).and_return(requirement)
    end

    [:create, :destroy, :update,].each do |action|
      describe("##{action}") do
        context("a private qfd") do
          it "should deny access" do
            do_update

            response.should be_permission_denied, response.status
          end
        end

        context("a collaborative qfd") do
          it "should succeed" do
            subject.stub(:filter_access_filter).and_return(true)
            subject.stub(:inner_name_for)
            
            do_update

            response.should_not be_permission_denied, response.status
          end
        end
      end
    end
  end

  context "owner" do

    before(:each) do
      logout
      login
      requirement = mock_model(Requirement, :update_attributes => true)
      Requirement.stub(:find).and_return(requirement)
    end

    [:create, :destroy, :update,].each do |action|
      describe("##{action}") do
        context("my qfd") do
          it "should succeed" do
            subject.stub(:filter_access_filter).and_return(true)
            subject.stub(:inner_name_for)

            do_update

            response.should_not be_permission_denied, response.status
          end
        end
      end
    end
  end


  private

  def do_update(params={})
    post :update, {:id => "1", :requirement => {:name => "Foo"}}.merge(params)
  end

  def do_create(params={})
    post :create, {:requirement => {:name => "Foo"}}.merge(params)
  end

  def do_destroy(params={})
    post :destroy, {:id => "1"}.merge(params)
  end

end
