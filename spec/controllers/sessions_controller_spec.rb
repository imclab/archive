require 'spec_helper'

describe SessionsController do
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
        @attr = {
          "2011.08.09" => ["01.testing.mp3", "02.testing.mp3"],
          "2011.09.09" => ["01.testing.mp3", "02.testing.mp3"]
        }
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

  describe "DELETE 'destroy'" do
    before(:each) do
      @user = create_user
      @session = Session.create!(:session_date => Time.now)
      @song1 = @session.songs.create!(:file_name => "01.file.mp3")
      @song2 = @session.songs.create!(:file_name => "02.file.mp3")
    end

    describe "as non-signed-in user" do
      it "should deny access" do
        delete :destroy, :id => @session
        response.should redirect_to(signin_path)
      end
    end

    describe "as non-admin user" do
      before(:each) do
        controller_sign_in(@user)
      end

      it "should protect page and redirect" do
        delete :destroy, :id => @session
        response.should redirect_to(sessions_path)
      end
    end

    describe "as admin user" do
      before(:each) do
        @user.toggle!(:admin)
        controller_sign_in(@user)
      end

      it "should delete the session" do
        lambda do
          delete :destroy, :id => @session
        end.should change(Session, :count).by(-1)
      end

      it "should delete associated songs" do
        lambda do
          delete :destroy, :id => @session
        end.should change(Song, :count).by(-2)
      end

      it "should delete tags associated to songs" do
        @song1.tags.create!(name: 'great')
        @song2.tags.create!(name: 'super')
        lambda do
          delete :destroy, :id => @session
        end.should change(Tag, :count).by(-2)
      end

      it "should redirect" do
        delete :destroy, :id => @session
        response.should redirect_to(sessions_path)
      end
    end
  end
end
