require 'spec_helper'

describe "Sessions" do

  describe "GET 'index'" do
    it "should have the right title" do
      visit '/sessions'
      current_path.should == sessions_path
      page.should have_css('title',
                           :text => 'Howling Vibes Archive | All sessions')
    end

    describe "clicking on the 'Show' links" do
      before(:each) do
        @old_session = Session.create!(session_date: Time.now - 2.days)
        @old_song = @old_session.songs.create!(file_name: "01.breaking.bad.mp3") 
        
        @new_session = Session.create!(session_date: Time.now)
        @new_song = @new_session.songs.create!(file_name: "03.hello_joe.mp3")
      end

      it "should show the oldest session on top when clicked on 'Oldest'" do
        visit '/sessions/'
        click_link "Oldest"
        page.body.should =~ /#{@old_song.file_name}.*#{@new_song.file_name}/m
      end

      it "should show the newest session on top when clicked on 'Newest'" do
        visit '/sessions/'
        click_link "Newest"
        page.body.should =~ /#{@new_song.file_name}.*#{@old_song.file_name}/m
      end
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
