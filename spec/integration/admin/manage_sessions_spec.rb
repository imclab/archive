require 'spec_helper'

describe 'Managing sessions' do
  before(:each) do
    user = create_user('admin@gmail.com', 'password')
    user.toggle!(:admin)

    admin_integration_sign_in('admin@gmail.com', 'password')
  end

  describe 'adding a new session' do
    it 'allows me to add a new session' do
      click_link 'Sessions'

      page.should have_content('No sessions found')

      click_link 'Add new session'

      page.should have_content('01.down.south.mp3')

      check '01.down.south.mp3'
      click_button 'Add selected files'

      page.should_not have_content('No sessions found')
      page.should have_content('01.down.south.mp3')
    end

    it 'gives me an error message when no file is selected' do
      click_link 'Sessions'
      click_link 'Add new session'

      click_button 'Add selected files'

      page.should have_content('Please select some files!')
    end

    context 'with some songs already saved' do
      let(:session) do
        Session.create!(session_date: Date.strptime("2011.07.14","%Y.%m.%d"))
      end

      before(:each) do
        session.songs.create!(file_name: '01.golden_fields.mp3')

        click_link 'Sessions'
      end

      it 'does not list songs as addable that are already saved' do
        click_link 'Add new session'

        page.should_not have_content('01.golden_fields.mp3')
      end

      it 'lists session with only some files saved as addable' do
        click_link 'Add new session'

        page.should have_content('2011.07.14')
        page.should have_content('02.grapevine.mp3')
      end

      it 'does not list a session with all files already saved' do
        session.songs.create!(file_name: '02.grapevine.mp3')

        click_link 'Add new session'

        page.should_not have_content('2011.07.14')
      end
    end
  end

  describe 'deleting a session' do
    let(:session) do
      Session.create!(session_date: Date.strptime('2011.07.14','%Y.%m.%d'))
    end

    before(:each) do
      session.songs.create!(file_name: '01.golden_fields.mp3')
    end

    it 'allows me to delete a session' do
      click_link 'Sessions'

      page.should have_content('Delete this session')
      click_link 'Delete this session'

      page.should_not have_content('01.golden_fields.mp3')
    end
  end
end

