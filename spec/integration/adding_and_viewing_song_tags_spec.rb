require 'spec_helper'

describe 'adding and viewing song tags' do
  before(:each) do
    songs_session = Session.create!(session_date: 2.days.ago)
    songs_session.songs.create!(file_name: '01.breaking.bad.mp3')
  end

  context 'as a logged-in user' do
    before(:each) do
      create_user
      integration_sign_in
    end

    it 'allows me to add a tag to a song' do
      visit sessions_path
      click_link '01.breaking.bad.mp3'

      page.should have_content('This song has no tags!')

      within '#new_tag' do
        fill_in 'tag[name]', with: 'awesome'
        click_button 'Add Tag!'
      end

      page.should have_content('Tag "awesome" saved!')
      page.should have_css('span.tag', text: 'awesome')
      page.should_not have_content('This song has no tags!')
    end

    it 'shows me the errors when I make errors' do
      visit sessions_path
      click_link '01.breaking.bad.mp3'

      click_button 'Add Tag!'

      page.should have_content('Tag could not be added!')
    end
  end

  context 'as a logged-out user' do
    it 'does not give me the option to add tags' do
      visit sessions_path
      click_link '01.breaking.bad.mp3'

      page.should_not have_css('#new_tag')
    end
  end
end
