require 'spec_helper'

describe "Sessions" do

  describe "GET 'index'" do
    it "should have the right title" do
      visit '/sessions'
      current_path.should == sessions_path
      page.should have_css('title',
                           :text => 'Howling Vibes Archive | All sessions')
    end
  end

  describe "GET 'new' as non-user" do
    it "should redirect to sign-in page" do
      visit "/sessions/new"
      page.should  have_css('div.notification', :text => "Please sign in")
    end
  end

  describe "GET 'new' as non-admin user" do
    before(:each) do
      create_user
      integration_sign_in
    end
    it "should redirect to sessions_path and give notice" do
      visit '/sessions/new'
      page.should have_css('div.notification',
                           :text => "Sorry, you are not allowed to do this")
    end
  end
end
