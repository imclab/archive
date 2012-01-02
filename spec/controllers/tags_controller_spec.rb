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
                      :content => @base_title + " | All tags")
    end
  end
end
