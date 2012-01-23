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

  describe "GET 'edit'" do
    before(:each) do
      @user = create_user
      controller_sign_in(@user)
    end

    it "should be successful" do
      get :edit, :id => @user
      response.should be_success
    end
  end

  describe "PUT 'update'" do
    before(:each) do
      @user = create_user
      controller_sign_in(@user)
    end

    describe "failure" do
      before(:each) do
        @attr = { :email => "", :name => "", :password => "",
                  :password_confirmation => "" }
      end

      it "should render the 'edit' page" do
        put :update, :id => @user.id, :user => @attr
        response.should render_template('edit')
      end
    end

    describe "success" do 
      before(:each) do
        @attr = { :email => "johnny22@foobar.com", :name => "Johnny Second",
                  :password => "password",
                  :password_confirmation => "password" }
      end

      it "should change the user's attributes" do
        put :update, :id => @user, :user => @attr
        @user.reload
        @user.name.should == @attr[:name]
        @user.email.should == @attr[:email]
      end

      it "should redirect to the sessions_page" do
        put :update, :id => @user, :user => @attr
        response.should redirect_to(sessions_path)
      end
    end
  end
end
