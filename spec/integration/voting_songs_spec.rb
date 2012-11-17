require 'spec_helper'

describe 'voting for a song' do
  let(:session) {
    Session.create!(session_date: Time.now)
  }

  before(:each) do
    @song = session.songs.create!(file_name: '01.testing.mp3')
  end

  it 'allows visitors to upvote and downvote a song' do
    visit song_path(@song)

    click_on 'Upvote'

    page.should have_css('span.score', text: '1')

    click_on 'Downvote'

    page.should have_css('span.score', text: '0')
  end
end
