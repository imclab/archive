require 'spec_helper'

describe 'new comment notification' do
  let(:session) {
    Session.create!(session_date: Date.today)
  }

  before(:each) do
    create_user('comment_viewer@gmail.com')
    @comment_maker = create_user('comment_maker@gmail.com')
    @song          = session.songs.create!(file_name: '01.testing.mp3')
  end

  it 'shows me comments that have been made since my last visit' do
    integration_sign_in('comment_viewer@gmail.com')
    click_on 'Sign out'

    Comment.create!(user: @comment_maker, song: @song, text: 'I wrote this in your absence')

    integration_sign_in('comment_viewer@gmail.com')

    click_on '1 new comment'

    within ('#info-bar') do
      click_on '01.testing.mp3'
    end

    page.should have_content('I wrote this in your absence')
  end

  it 'only shows me comments that have been made since my last activity' do
    integration_sign_in('comment_viewer@gmail.com')
    click_on 'TAGS'

    Comment.create!(user: @comment_maker, song: @song, text: 'This is a second comment')
    Comment.create!(user: @comment_maker, song: @song, text: 'This is a third comment')

    click_on 'SONGS'

    page.should have_content('2 new comments')
  end
end
