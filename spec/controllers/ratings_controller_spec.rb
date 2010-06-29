require 'spec_helper'

describe RatingsController do

  context "guests" do

    before(:each) do
      logout
      login_as_guest
    end

    describe("#update") do
      context("a public qfd") do
        it "should deny access"
      end

      context("a private qfd") do
        it "should deny access"
      end
    end
  end

  context "user" do

    before(:each) do
      logout
      login
    end

    describe("#update") do
      context("a private qfd") do
        it "should deny access"
      end

      context("a collaborative qfd") do
        it "should succeed"
      end
    end
  end

  context "owner" do

    before(:each) do
      logout
      login
    end

    describe("#update") do
      context("my qfd") do
        it "should succeed"
      end
    end

  end
end
