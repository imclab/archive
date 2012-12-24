require "spec_helper"

describe "Admin Tasks" do
  before(:each) do
    user = create_user
    user.toggle!(:admin)
    integration_sign_in
  end

  describe 'DELETE a song in show page' do
    before(:each) do
      @session = Session.create(session_date: Time.now)
      @song    = @session.songs.create(file_name: "01.testing.mp3")
      visit song_path(@song)
    end

    it 'should show a DELETE link next to the songs name' do
      page.should have_css('span.delete')
      page.should have_link('Delete this song', href: "/songs/#{@song.id}")
    end
  end
end
