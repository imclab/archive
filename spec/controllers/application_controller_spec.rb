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

  context 'as signed-in user' do
    before(:each) do
      controller_sign_in(create_user)
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

  context 'as signed-out user' do
    it 'does not save the visitors last activity' do
      get :index

      cookies[:last_activity].should be_nil
    end
  end
end
