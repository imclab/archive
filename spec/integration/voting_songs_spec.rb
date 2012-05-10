require 'spec_helper'

describe "Voting Songs" do
  before(:each) do
    session = Session.create!(session_date: Time.now)
    @song = session.songs.create!(file_name: "01.testing.mp3")
  end

  it "allows visitors to upvote a song" do
    visit song_path(@song)
    click_on "Upvote"
    page.should have_css("span.score", text: "1")
  end

  it "allows visitors to downvote a song" do
    visit song_path(@song)
    click_on "Downvote"
    page.should have_css("span.score", text: "-1")
  end
end
