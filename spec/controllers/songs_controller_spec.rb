require 'spec_helper'

describe SongsController do
  render_views

  before(:each) do
    @base_title = "Howling Vibes Archive"
  end
  
  describe "GET 'index'" do
    it "should be successful" do
      get :index
      response.should be_success
    end

    it "should have the right title" do
      get :index
      response.should have_selector("title",
                      :content => @base_title + " | All songs")
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
  end
end
