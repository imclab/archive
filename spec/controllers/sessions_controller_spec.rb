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

    it "should have the right title" do
      get :index
      response.should have_selector("title",
                      :content => @base_title + " | All sessions")
    end

  end

  describe "GET 'new'" do
    it "should be successful" do
      get :new
      response.code.should eq("200")
    end
    
    it "should have the right title" do
      get :new
      response.body.should have_selector("title", :content => "Add session")
    end

    it "should show files in fixtures/archive" do
      get :new
      response.should have_selector("li", :content => "01.down.south.mp3") 
    end

    it "should NOT show a song that is already in DB" do
      se1 = Session.new(:session_date => Date.strptime("2011.07.14","%Y.%m.%d"))
      se1.songs.build(:file_name => "01.golden_fields.mp3")
      se1.save
      get :new
      response.should_not have_selector("li", :content =>"01.golden_fields.mp3")
    end

    it "should show a session with some files not yet in DB" do
      se1 = Session.new(:session_date => Date.strptime("2011.07.14","%Y.%m.%d"))
      se1.songs.build(:file_name => "01.golden_fields.mp3")
      se1.save
      get :new
      response.should have_selector("li", :content => "02.grapevine.mp3")
    end

    it "should NOT show a session with all files already in DB" do
      se1 = Session.new(:session_date => Date.strptime("2011.07.14","%Y.%m.%d"))
      se1.songs.build(:file_name => "01.golden_fields.mp3")
      se1.songs.build(:file_name => "02.grapevine.mp3")
      se1.save
      get :new
      response.should_not have_selector("p", :content => "2011.07.14")
    end
  end

  describe "POST 'create'" do

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
end
