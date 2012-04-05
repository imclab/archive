require 'spec_helper'

describe ApplicationController do
  controller do
    def index
      render nothing: true
    end

    def create
      render nothing: true
    end
  end

  context "with user" do
    before(:each) do
      user = create_user
      controller_sign_in(user)
    end

    it 'saves the users last activity' do
      time = Time.now
      Time.stub(now: time)

      get :index

      cookies[:last_activity].should == time
    end

    it 'only saves users last activity after GET requests' do
      post :create

      cookies[:last_activity].should be_nil
    end
  end

  context "without current_user" do
    it 'does not save the visitors last activity' do
      get :index

      cookies[:last_activity].should be_nil
    end
  end
end