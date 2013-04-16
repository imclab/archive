require 'spec_helper'

describe 'viewing sessions' do
  describe 'on the index page' do
    describe 'clicking on the Show links' do
      before(:each) do
        old_session = Session.create!(session_date: 2.days.ago)
        @old_song = old_session.songs.create!(file_name: '01.breaking.bad.mp3')

        new_session = Session.create!(session_date: Date.today)
        @new_song = new_session.songs.create!(file_name: '03.hello_joe.mp3')
      end

      it 'should show the oldest session on top when clicked on Oldest' do
        visit '/sessions/'

        click_link 'Oldest'

        page.body.should =~ /#{@old_song.file_name}.*#{@new_song.file_name}/m
      end

      it 'should show the newest session on top when clicked on Newest' do
        visit '/sessions/'

        click_link 'Newest'

        page.body.should =~ /#{@new_song.file_name}.*#{@old_song.file_name}/m
      end
    end
  end
end
