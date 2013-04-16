require 'spec_helper'

describe 'viewing songs' do
  describe 'on the songs index page' do
    before(:each) do
      @old_session = Session.create!(session_date: Time.now - 2.days)
      @old_song = @old_session.songs.create!(file_name: "01.breaking.bad.mp3")

      @new_session = Session.create!(session_date: Time.now)
      @new_song = @new_session.songs.create!(file_name: "01.hello_joe.mp3")
    end

    it 'should show a songs list' do
      visit songs_path

      page.should have_content('01.breaking.bad.mp3')
      page.should have_content('01.hello_joe.mp3')
    end

    describe 'changing the order of the song list' do
      it 'shows the oldest songs when clicking on Oldest' do
        visit songs_path

        click_link 'Oldest'

        page.body.should =~ /#{@old_song.file_name}.*#{@new_song.file_name}/m
      end

      it 'shows the newest songs on top when clicking on Newest' do
        visit songs_path

        click_link 'Newest'

        page.body.should =~ /#{@new_song.file_name}.*#{@old_song.file_name}/m
      end

      it 'shows the most tagged song on top when clicked on most tagged' do
        @old_song.tags.create!(name: 'hello there')
        @old_song.tags.create!(name: 'and you')
        @new_song.tags.create!(name: 'woohoo')

        visit songs_path

        click_link 'Most Tagged'

        page.body.should =~ /#{@old_song.file_name}.*#{@new_song.file_name}/m
      end

      it 'shows the song with the highest score when clicked on Highest Score' do
        @old_song.update_attribute(:score, 50)
        @new_song.update_attribute(:score, 80)

        visit songs_path

        click_link 'Highest Score'

        page.body.should =~ /#{@new_song.file_name}.*#{@old_song.file_name}/m
      end
    end
  end
end
