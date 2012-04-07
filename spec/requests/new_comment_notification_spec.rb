require 'spec_helper'

describe 'new comment notification' do
  before(:each) do
    @klaus  = create_user("klaus@web.de")
    @peter  = create_user("peter@gmx.de")
    session = Session.create!(session_date: Date.today)
    @song   = session.songs.create!(file_name: "01.testing.mp3")
    Comment.create!(user_id: @klaus.id, song_id: @song.id, text: "This is a comment")
  end

  it 'shows me comments that have been made since my last visit', js: true do
    integration_sign_in("peter@gmx.de")
    click_on "SONGS"
    # puts "XXXXXXXXXXXXXXXXXXXXXXXXX"
    # puts "Cookie:"
    # puts cookies[:last_activity]
    # puts "Cookie.nil?:"
    # puts cookies[:last_activity].nil?

    click_on "1 new comment"
    click_on "klaus commented on 01.testing.mp3"
    page.should have_content("This is a comment")
    current_path.should == song_path(@song)
  end

  it 'show me comments that have been made since my last activity' do
    integration_sign_in("peter@gmx.de")
    click_on "TAGS"
    # puts "XXXXXXXXXXXXXXXXXXXXXXXXX"
    # puts "Cookie:"
    # puts cookies[:last_activity]
    # puts "Cookie.nil?:"
    # puts cookies[:last_activity].nil?

    newcomment1 = Comment.create!(user: @klaus, song: @song, text: "This is a second comment")
    newcomment2 = Comment.create!(user: @klaus, song: @song, text: "This is a third comment")
    puts "Comments:"
    puts newcomment1.created_at
    puts newcomment2.created_at
    # puts "--------------------------"

    click_on "SONGS"

    page.should have_content("2 new comments")
  end
end
