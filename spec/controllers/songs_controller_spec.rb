require 'spec_helper'

describe SongsController do

  describe "GET 'index'" do
    it "should be successful" do
      get :index
      response.should be_success
    end
  end

  describe "GET 'show'" do

    before(:each) do
      @session = Session.create!(session_date: Time.now)
      @song = @session.songs.create!(file_name: "01.breaking.bad.mp3") 
    end

    it "should be successful" do
      get :show, :id => @song
      response.should be_success
    end
    
    it "should find the right song" do
      get :show, :id => @song
      assigns(:song).should == @song
    end

    it "saves the current path in session variable" do
      get :show, :id => @song
      session[:return_to].should == song_path(@song)
    end
  end

  describe "DELETE 'destroy'" do
    before(:each) do
      @user = create_user
      @song = Song.create!(:file_name => "01.file.mp3")
      @other_song = Song.create!(:file_name => "02.file.mp3")
    end

    describe "as non-signed-in user" do
      it "should deny access" do
        delete :destroy, :id => @song
        response.should redirect_to(signin_path)
      end
    end

    describe "as non-admin user" do
      it "should protect page and redirect" do
        controller_sign_in(@user)
        delete :destroy, :id => @song
        response.should redirect_to(sessions_path)
      end
    end

    describe "as admin user" do
      before(:each) do
        @user.toggle!(:admin)
        controller_sign_in(@user)
      end

      it "should delete the song" do
        lambda do
          delete :destroy, :id => @song
        end.should change(Song, :count).by(-1)
      end

      it "should redirect" do
        delete :destroy, :id => @song
        response.should redirect_to(sessions_path)
      end
    end
  end
end
