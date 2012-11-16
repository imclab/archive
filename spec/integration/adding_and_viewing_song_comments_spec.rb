require 'spec_helper'

describe 'adding and viewing song comments' do
  before(:each) do
    songs_session = Session.create!(session_date: 2.days.ago)
    songs_session.songs.create!(file_name: '01.breaking.bad.mp3')
  end

  context 'as a logged in user' do
    before(:each) do
      create_user
      integration_sign_in
    end

    it 'allows me to add a comment to a song' do
      visit sessions_path
      click_link '01.breaking.bad.mp3'

      page.should have_content('This song has no comments, add some!')

      within '#new_comment' do
        fill_in "comment[text]", :with => 'This is a test comment'
        click_button 'Add Comment!'
      end

      page.should have_content('You successfully added a comment!')
      page.should have_content('This is a test comment')
      page.should_not have_content('This song has no comments, add some!')
    end

    it 'shows me the errors when I make errors' do
      visit sessions_path
      click_link '01.breaking.bad.mp3'

      within '#new_comment' do
        click_button 'Add Comment!'
      end

      page.should have_content('Comment could not be added!')
    end

    it 'allows me to delete my own comments' do
      visit sessions_path
      click_link '01.breaking.bad.mp3'

      within '#new_comment' do
        fill_in "comment[text]", :with => 'Im deleting this!'
        click_button 'Add Comment!'
      end

      click_link 'Delete this comment'

      page.should_not have_content('Im deleting this!')
      page.should have_content('You successfully deleted a comment!')
    end

    it 'does not allow me to delete the songs of other users' do
      other_user = create_user('anotherdude@gmail.com')
      Comment.create!(song: Song.last, user: other_user, text: 'Dont delete this')


      visit sessions_path
      click_link '01.breaking.bad.mp3'

      page.should_not have_content('Delete this comment')
    end
  end

  context 'as a logged-out user' do
    it 'does not give me the option to add comments' do
      visit sessions_path
      click_link '01.breaking.bad.mp3'

      page.should_not have_css('#new_comment')
    end
  end
end
