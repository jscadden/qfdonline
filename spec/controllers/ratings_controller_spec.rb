require 'spec_helper'

describe RatingsController do

  context "guests" do

    before(:each) do
      logout
      login_as_guest
      Rating.stub(:find).and_return(mock_model(Rating))
    end

    [:update, :create, :destroy].each do |action|
      describe("##{action}") do

        context("a public qfd") do
          it "should deny access" do
            send("do_#{action}")

            response.should be_permission_denied
          end
        end

        context("a private qfd") do
          it "should deny access" do
            send("do_#{action}")

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
      rating = mock_model(Rating, :update_attributes => true, :secondary_hoq => nil)
      qfd = mock_model(Qfd)
      rating.stub_chain(:primary_requirement, :requirements_list, :primary_hoq, :hoq_list, :qfd).and_return(qfd)
      Rating.stub(:find).and_return(rating)
    end

    [:create, :destroy, :update].each do |action|
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
      rating = mock_model(Rating, :update_attributes => true)
      Rating.stub(:find).and_return(rating)
    end

    [:create, :destroy, :update].each do |action|
      describe("##{action}") do
        context("my qfd") do
          it "should succeed" do
            subject.stub(:filter_access_filter).and_return(true)

            do_update

            response.should_not be_permission_denied, response.status
          end
        end
      end
    end

  end


  private

  def do_update(params={})
    post :update, {:id => "1", :rating => {:value => "5"}}.merge(params)
  end

  def do_create(params={})
    post :create, {:rating => {:value => "5"}}.merge(params)
  end

  def do_destroy(params={})
    post :destroy, {:id => "1"}.merge(params)
  end

end
