require 'spec_helper'

describe 'Managing songs' do
  let(:admin) do
    create_user
  end

  let(:session) do
    session = Session.create!(session_date: Time.now)
  end

  let(:song) do
    session.songs.create!(file_name: '01.testing.mp3')
  end

  before(:each) do
    admin.toggle!(:admin)
    admin_integration_sign_in
  end

  it 'allows me to see a songs tags and comments' do
    song.comments.create!(user: admin, text: 'This is a comment')
    song.tags.create!(name: 'amazing')

    click_link 'Songs'
    click_link '01.testing.mp3'

    page.should have_content('This is a comment')
    page.should have_content('amazing')
  end

  it 'allows me to delete a song' do
    session = Session.create!(session_date: Time.now)
    session.songs.create!(file_name: '01.testing.mp3')

    click_link 'Songs'

    page.should have_content('01.testing.mp3')

    click_link 'Delete this song'

    page.should_not have_content('01.testing.mp3')
  end
end
