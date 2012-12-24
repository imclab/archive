require "spec_helper"

describe "Admin Tasks" do
  before(:each) do
    user = create_user
    user.toggle!(:admin)
    integration_sign_in
  end

  describe "Admin links in user bar" do
    it "should show a link to list users" do
      visit root_path
      page.should have_link('List users', :href => users_path)
    end
  end

  describe "DELETE a session in sessions index" do
    before(:each) do
      @session = Session.create!(session_date: Time.now)
      @session.songs.create!(file_name: "01.testing.mp3")
      visit '/sessions'
    end

    it "should show a DELETE link next to the session name" do
      page.should have_css('span.delete')
      page.should have_link('Delete this session', href: "/sessions/#{@session.id}")
    end
  end

  describe "DELETE a song in show page" do
    before(:each) do
      @session = Session.create(session_date: Time.now)
      @song    = @session.songs.create(file_name: "01.testing.mp3")
      visit song_path(@song)
    end

    it "should show a DELETE link next to the songs name" do
      page.should have_css('span.delete')
      page.should have_link('Delete this song', href: "/songs/#{@song.id}")
    end
  end

  describe "DELETE a user in users index page" do
    describe "GET 'index'" do
      before(:each) do
        @testuser = create_user("test@user.com", "Test User")
      end

      it "should show a delete link" do
        visit '/users'
        page.should have_css("ul.user-list")
        page.should have_link('Delete this user', href: "/users/#{@testuser.id}")
      end
    end
  end
end
