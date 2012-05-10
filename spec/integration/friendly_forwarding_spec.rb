require 'spec_helper'

describe 'Friendly Forwarding' do
  before(:each) do
    create_user
    session = Session.create!(session_date: Time.now)
    @song   = session.songs.create!(file_name: "01.testing.mp3")
  end

  it "redirects user to previous path after login" do
    visit song_path(@song)
    integration_sign_in

    page.should have_content("01.testing.mp3")
    current_path.should == song_path(@song)
  end
end
