require "spec_helper"

describe QfdsController do

  context "guests" do

    before(:each) do
      logout
      login_as_guest
    end

    describe("#show") do
      context("a public qfd") do
        it "should redirect to the first hoq" do
          hoq = mock_model(Hoq)
          qfd = mock_model(Qfd, :public => true, :hoqs => [hoq,])
          Qfd.stub(:find).and_return(qfd)
          Qfd.stub_chain(:hoqs, :first => hoq)
          
          get :show

          response.should redirect_to(qfd_hoq_path(qfd, hoq))
        end
      end

      context("a private qfd") do
        it "should deny access" do
          Qfd.stub(:find).and_return([])
          
          get :show

          response.should be_permission_denied
        end
      end
    end
  end

  context "user" do

    before(:each) do
      logout
      login
    end

    describe("#show") do
      context("a private qfd") do
        it "should deny access" do
          Qfd.stub(:find).and_return([])
          
          get :show

          response.should be_permission_denied
        end
      end

      context("a collaborative qfd") do
        it "should redirect to the first hoq" do
          hoq = mock_model(Hoq)
          qfd = mock_model(Qfd, :public => true, :hoqs => [hoq,])
          Qfd.stub(:find).and_return(qfd)
          
          get :show

          response.should redirect_to(qfd_hoq_path(qfd, hoq))
        end
      end
    end
  end
end
