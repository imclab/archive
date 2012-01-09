require 'spec_helper'

describe TagsController do
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
                                    content: @base_title + " | All tags")
    end

    it "should have an element for each tag" do
      song1 = Song.create!(file_name: "01.testing.mp3")
      song2 = Song.create!(file_name: "02.testing.mp3")
      song1.add_tag("supertest")
      song2.add_tag("greattest")
      get :index
      response.should have_selector("span.tag", content: "supertest")
      response.should have_selector("span.tag", content: "greattest")
    end
  end

  describe "GET 'show'" do

    before(:each) do
      @tag = Tag.create!(name: "testing")
      @song1 = Song.create!(file_name: "01.testing.mp3")
      @song2 = Song.create!(file_name: "02.testing.mp3")
      @tag.song_tags.create!(song_id: @song1.id)
      @tag.song_tags.create!(song_id: @song2.id)
    end

    it "should be successful" do
      get :show, :id => @tag
      response.should be_success
    end

    it "should find the right user" do
      get :show, :id => @tag
      assigns(:tag).should == @tag
    end

    it "should find the right associated songs" do
      get :show, :id => @tag
      assigns(:songs).should == [@song1, @song2]
    end
  end
end
