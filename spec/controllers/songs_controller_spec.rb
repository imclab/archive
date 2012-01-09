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

    describe "Tags" do
      it "should print message if no tags are associated" do
        get :show, :id => @song
        response.should have_selector('span.no-tags',
                                  content: "This song has no tags! Add some!")
      end

      it "should show the associated tags" do
        @song.add_tag('great')
        get :show, :id => @song
        response.should have_selector('span.tag', content: 'great')
      end
    end
  end
end
