require "spec_helper"

describe "Admin Tasks" do
  before(:each) do
    @user = create_user
    @user.toggle!(:admin)
    integration_sign_in
  end

  describe "Admin links in user bar" do
    it "should show a link to add sessions" do
      visit root_path
      page.should have_css('span.admin_tasks')
      page.should have_link('Add new sessions',  :href => new_session_path)
    end
    it "should show a link to list users" do
      visit root_path
      page.should have_link('List users', :href => users_path)
    end
  end

  describe "Adding new sessions" do
    it "should show files in fixtures/archive" do
      visit '/sessions/new'
      page.should have_content('01.down.south.mp3')
    end

    it "should render the correct template" do
      visit '/sessions/new'
      current_path.should == new_session_path
      page.should have_css('title',
                           :text => 'Howling Vibes Archive | Add session')
      page.should have_css('h3', :text => 'Add new sessions')
    end

    it "should not show a song that is already in DB" do
      se1 = Session.new(:session_date => Date.strptime('2011.07.14','%Y.%m.%d'))
      se1.songs.build(:file_name => '01.golden_fields.mp3')
      se1.save
      visit '/sessions/new'
      page.should_not have_content('01.golden_fields.mp3')
    end

    it "should show a sessions with some files not yet in DB" do
      se1 = Session.new(:session_date => Date.strptime("2011.07.14","%Y.%m.%d"))
      se1.songs.build(:file_name => "01.golden_fields.mp3")
      se1.save
      visit '/sessions/new'
      page.should have_content('2011.07.14')
      page.should have_content('02.grapevine.mp3')
    end

    it "should NOT show a session with all files already in DB" do
      se1 = Session.new(:session_date => Date.strptime("2011.07.14","%Y.%m.%d"))
      se1.songs.build(:file_name => "01.golden_fields.mp3")
      se1.songs.build(:file_name => "02.grapevine.mp3")
      se1.save
      visit '/sessions/new'
      page.should_not have_css('p', :text => '2011.07.14')
    end

    describe "adding new sessions/songs via form" do

      it "should add selected sessions/songs" do
        visit '/sessions/new'

        check 'zombies_in_hospital_beds.mp3'
        click_button 'Add selected files' 

        page.should have_css('h3', :text => 'ALL SESSIONS!')
        current_path.should == sessions_path
        page.should have_content('zombies_in_hospital_beds.mp3')
      end
    end

    it "should print message when no song is selected" do
      visit '/sessions/new'
      page.should have_css('h3', :text => 'Add new sessions')
      
      # Don't click a checkbox
      click_button 'Add selected files' 
      page.should have_css('div.notification')
      page.should have_content('Please select some files!')
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
      page.should have_link('Delete this session', 
                            href: "/sessions/#{@session.id}")
    end
  end

  describe "DELETE a song in show page" do
    before(:each) do
      @song = Song.create(file_name: "01.testing.mp3")
      visit song_path(@song)
    end

    it "should show a DELETE link next to the songs name" do
      page.should have_css('span.delete')
      page.should have_link('Delete this song',
                            href: "/songs/#{@song.id}")
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
        page.should have_link('Delete this user', 
                              href: "/users/#{@testuser.id}")
      end
    end
  end
end
