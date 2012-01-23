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

  describe "GET 'new' as admin" do
    before(:each) do
      admin = create_user
      admin.toggle!(:admin)
      integration_sign_in
    end

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
