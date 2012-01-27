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

  describe "authentication of edit/update actions" do
    before(:each) do
      @user = create_user
    end

    describe "for non-signed in users" do

      it "should deny access to 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(signin_path)
      end

      it "should deny access to 'update'" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(signin_path)
      end
    end

    describe "for signed-in users" do
      before(:each) do
        wrong_user = create_user("evil@evil.com", "evilpass")
        controller_sign_in(wrong_user)
      end

      it "should require matching users for 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(root_path)
      end

      it "should require matching users for 'update'" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(root_path)
      end
    end
  end
  describe "DELETE 'destroy'" do

    before(:each) do
      @user = create_user
    end

    describe "as a non-signed-in user" do
      it "should deny access" do
        delete :destroy, :id => @user
        response.should redirect_to(signin_path)
      end
    end

    describe "as a non-admin user" do
      it "should protect the page" do
        controller_sign_in(@user)
        delete :destroy, :id => @user
        response.should redirect_to(sessions_path)
      end
    end

    describe "as an admin user" do

      before(:each) do
        @admin = create_user("admin@admin.com")
        @admin.toggle!(:admin)
        controller_sign_in(@admin)
      end

      it "should destroy the user" do
        lambda do
          delete :destroy, :id => @user
        end.should change(User, :count).by(-1)
      end

      it "should redirect to the users page" do
        delete :destroy, :id => @user
        response.should redirect_to(sessions_path)
      end
    end
  end
end
