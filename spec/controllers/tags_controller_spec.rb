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

  describe "POST 'create'" do

    before(:each) do
      @song = Song.create(file_name: "testing.mp3")
      @user = create_user
      controller_sign_in(@user)
    end

    describe "failure" do
      before(:each) do
        @attr = { :name => "", :song_id => @song.id }
      end

      it "should not create a tag" do
        lambda do
          post :create, :tag => @attr
        end.should_not change(Tag, :count).by(1)
      end

      it "should render the songs page" do
        post :create, :tag => @attr
        response.should redirect_to(song_path(@song.id))
      end
    end

    describe "success" do

      before(:each) do
        @attr = { :name => "greeeat!", :song_id => @song.id }
      end

      it "should create a tag" do
        lambda do 
          post :create, :tag => @attr
        end.should change(Tag, :count).by(1)
      end

      it "should redirect to songs page" do
        post :create, :tag => @attr
        response.should redirect_to(song_path(@song.id))
      end
    end
  end

  describe "authentication of 'create action'" do
    before(:each) do
      @song = Song.create(file_name: "testing.mp3")
      @attr = { :name => "greeeat!", :song_id => @song.id }
      @user = create_user
    end

    describe "for non-signed in users" do
      it "should deny access to 'new'" do
        post :create, :tag => @attr
        response.should redirect_to(signin_path)
      end
    end
  end
end
