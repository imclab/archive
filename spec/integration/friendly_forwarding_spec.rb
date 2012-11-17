require 'spec_helper'

describe 'friendly forwarding' do
  let(:session) {
    Session.create!(session_date: Time.now)
  }

  before(:each) do
    create_user
    @song = session.songs.create!(file_name: "01.testing.mp3")
  end

  it 'redirects user to previous path after login' do
    visit song_path(@song)

    integration_sign_in

    current_path.should == song_path(@song)
  end
end
