require 'spec_helper'

describe 'new comment notification' do
  before(:each) do
    @klaus  = create_user("klaus@web.de")
    @peter  = create_user("peter@gmx.de")
    session = Session.create!(session_date: Date.today)
    @song   = session.songs.create!(file_name: "01.testing.mp3")
  end

  it 'shows me comments that have been made since my last visit' do
    # Making a visit, then logging out
    integration_sign_in("peter@gmx.de")
    click_on "Sign out"
    # While I'm gone: klaus posts a comment
    Comment.create!(user_id: @klaus.id, song_id: @song.id, text: "This is a comment")
    # I sign in again
    integration_sign_in("peter@gmx.de")

    # shows me new comments since last visit
    click_on "1 new comment"
    within ("#info-bar") do
      click_on "01.testing.mp3"
    end
    page.should have_content("This is a comment")
    current_path.should == song_path(@song)
  end

  it 'show me comments that have been made since my last activity' do
    Comment.create!(
      user_id: @klaus.id,
      song_id: @song.id,
      text: "This is a comment",
      created_at: Time.now - 5.days.ago
    )
    integration_sign_in("peter@gmx.de")
    click_on "TAGS"
    Comment.create!(user: @klaus, song: @song, text: "This is a second comment")
    Comment.create!(user: @klaus, song: @song, text: "This is a third comment")

    click_on "SONGS"

    page.should have_content("2 new comments")
  end
end
