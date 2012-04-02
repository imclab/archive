require 'spec_helper'

describe UserSessionsController do

  describe "GET 'new'" do
    it "should be successful" do
      get :new
      response.should be_success
    end
  end

  describe "GET '/signin'" do
    it "should be successful" do
      visit '/signin'
      response.should be_success
    end
  end

  describe "POST 'create'" do
    describe "invalid signin" do

      before(:each) do
        @attr = { :email => "email@example.com", :password => "invalid" }
      end

      it "should re-render the new page" do
        post :create, :user_session => @attr
        response.should render_template('new')
      end
    end

    describe "valid signin with valid email and password" do
      before(:each) do
        @user = stub('user', authenticate: true, id: 1, name: 'Robin')
        User.stub(find_by_email: @user)
      end

      it "should sign the user in" do
        User.should_receive(:find).with(1) { @user }
        post :create, :user_session => {}
        controller.current_user.should == @user
        controller.should be_signed_in
      end

      it "should redirect to the sessions page" do
        post :create, :user_session => {}
        response.should redirect_to(sessions_path)
      end

      it "redirects to return_to path" do
        session[:return_to] = '/bananensaft'

        post :create, :user_session => {}
        response.should redirect_to('/bananensaft')
      end

      it "clears return_to path after redirect" do
        session[:return_to] = '/bananensaft'

        post :create, :user_session => {}
        session[:return_to].should be_nil
      end
    end
  end

  describe "DELETE 'destroy'" do
    before(:each) do
      @user = User.create!(:name => "John Doe",
                   :email => "john@doe.org",
                   :password => "password",
                   :password_confirmation => "password")
      @attr = { :email => @user.email, :password => @user.password }
      post :create, :user_session => @attr
    end

    it "should sign user out" do
      delete :destroy
      controller.should_not be_signed_in
      controller.current_user.should == nil
      response.should redirect_to(sessions_path)
    end
  end
end
