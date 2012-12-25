require 'spec_helper'

describe 'Managing songs' do
  before(:each) do
    admin = create_user
    admin.toggle!(:admin)
    admin_integration_sign_in
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
