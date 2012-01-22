require 'spec_helper'

describe UsersController do

  describe "GET 'new'" do
    it "should be successful" do
      get :new
      response.code.should eq("200")
    end
  end

  describe "POST 'create'" do

    describe "failure" do
      before(:each) do
        @attr = { :name => "", :email => "", :password => "",
                  :password_confirmation => "" }
      end

      it "should not create a user" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end

      it "should redirect to the form" do
        post :create, :user => @attr
        response.should render_template("new")
      end
    end

    describe "success" do
      before(:each) do
        @attr = { :name => "New User", :email => "user@example.com",
                  :password => "foobar", :password_confirmation => "foobar" }
      end
      
      it "should create a user" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end

      it "should redirect to the index page" do
        post :create, :user => @attr
        response.should redirect_to(sessions_path) 
      end
    end
  end
end
