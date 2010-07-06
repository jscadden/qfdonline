require "spec_helper"

describe QfdsController do

  context "guests" do

    before(:each) do
      logout
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

          response.should be_permission_denied, response.status
        end
      end
    end

    describe("#index") do

      it "should render the public index" do
        get :index

        response.should render_template("qfds/index_public.html.haml")
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

    describe("#index") do

      before(:each) do
        Qfd.stub(:public).and_return([])
        Qfd.stub(:find).and_return([])
        @current_user.stub(:invitations_received).and_return([])
      end

      it "should render the private index template" do
        get :index

        response.should render_template("qfds/index_private.html.haml")
      end

      it "should render the public index template" do
        get :index, :public => "true"

        response.should render_template("qfds/index_public.html.haml")
      end
    end
  end
end
