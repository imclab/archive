require 'spec_helper'

describe SessionsController do
  render_views

  before(:each) do
    @base_title = "Howling Vibes Archive"
  end

  describe "GET 'index'" do
    it "should be successful" do
      get :index
      response.should be_success
    end
  end

  describe "GET 'new'" do
    before(:each) do
      @user = create_user
      @user.toggle!(:admin)
      controller_sign_in(@user)
    end

    it "should be successful for admins" do
      get :new
      response.code.should eq("200")
    end
  end

  describe "POST 'create' as admin" do
    before(:each) do
      @user = create_user
      @user.toggle!(:admin)
      controller_sign_in(@user)
    end

    describe "success with one session" do

      before(:each) do
        @attr = { "2011.08.09" => ["01.testing.mp3", "02.testing.mp3"] }
      end
      
      it "should create a session" do
        lambda do
          post :create, :sessions => @attr
        end.should change(Session, :count).by(1)
      end

      it "should redirect to the sessions index page" do
        post :create, :sessions => @attr
        response.should redirect_to(sessions_path)
      end

      it "should have a success message" do
        post :create, :sessions => @attr
        flash[:success].should include "Session 2011.08.09 saved!"
      end
    end

    describe "success with multiple sessions" do

      before(:each) do
        @attr = { "2011.08.09" => ["01.testing.mp3", "02.testing.mp3"],
                  "2011.09.09" => ["01.testing.mp3", "02.testing.mp3"] }
      end

      it "should create two sessions" do
        lambda do
          post :create, :sessions => @attr
        end.should change(Session, :count).by(2)
      end

      it "should redirect to the sessions index page" do
        post :create, :sessions => @attr
        response.should redirect_to(sessions_path)
      end

      it "should have success message" do
        post :create, :sessions => @attr
        flash[:success].should include "Session 2011.08.09 saved!"
        flash[:success].should include "Session 2011.08.09 saved!"
      end
    end
  end

  describe "authentication of new/create actions" do
    before(:each) do
      @user = create_user
      controller_sign_in(@user)
    end

    describe "for signed in (non-admin) users" do

      it "should deny access to 'new'" do
        get :new
        response.should redirect_to(sessions_path)
      end

      it "should deny access to 'create'" do
        @attr = { "2011.08.09" => ["01.testing.mp3", "02.testing.mp3"],
                  "2011.09.09" => ["01.testing.mp3", "02.testing.mp3"] }
        post :create, :sessions => @attr
        response.should redirect_to(sessions_path)
      end
    end
  end
end
