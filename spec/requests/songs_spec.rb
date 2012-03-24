require 'spec_helper'

describe "Songs" do

  describe "GET 'index'" do
    it "should show a songs list" do
      @song = Song.create!(file_name: "01.testing.mp3")
      visit '/songs'
      current_path.should == songs_path
      page.should have_css("title",
                           :title => "Howling Vibes Archive | All songs")
      page.should have_css("ul.song-list")
      page.should have_link(@song.file_name, :href => song_path(@song))
    end

    describe "clicking on the 'Show' links" do
      before(:each) do
        @old_session = Session.create!(session_date: Time.now - 2.days)
        @old_song = @old_session.songs.create!(file_name: "01.breaking.bad.mp3") 
        
        @new_session = Session.create!(session_date: Time.now)
        @new_song = @new_session.songs.create!(file_name: "03.hello_joe.mp3")
      end

      it "should show the oldest songs when clicked on 'Oldest'" do
        visit '/songs'
        click_link "Oldest"
        page.body.should =~ /#{@old_song.file_name}.*#{@new_song.file_name}/m
      end

      it "should show the newest songs on top when clicked on 'Newest'" do
        visit '/songs/'
        click_link "Newest"
        page.body.should =~ /#{@new_song.file_name}.*#{@old_song.file_name}/m
      end

      it "should show the most tagged song on top when clicked on 'most tagged'" do
        @old_song.add_tag("hello there")
        @old_song.add_tag("and you")
        @new_song.add_tag("one tag")
        visit '/songs/'
        click_link "Most Tagged"
        page.body.should =~ /#{@old_song.file_name}.*#{@new_song.file_name}/m
      end
    end
  end

  describe "GET 'show'" do
    before(:each) do
      @session = Session.create!(session_date: Time.now)
      @song = @session.songs.create!(file_name: "01.breaking.bad.mp3") 
      create_user
      integration_sign_in
    end

    describe "song tags" do
      it "should show a message if no tags are associated" do
        visit song_path(@song)
        page.should have_css('span.no-tags',
                             :text => 'This song has no tags!')
      end

      it "should show the associated tags" do
        @song.add_tag('great')
        visit song_path(@song)
        page.should have_css('span.tag', :text => 'great')
      end

      describe "adding tags via form" do

        it "should add a tag when submitted via form and display it" do
          visit song_path(@song)
          fill_in "tag[name]", :with => 'superduper'
          click_button 'Add Tag!'
          page.should have_css('div.success', :text =>
                               'Tag "superduper" saved!')
          page.should have_css('span.tag', :text => 'superduper')
        end

        it "should print an error message when empty field was submitted" do
          visit song_path(@song)
          # No filling here
          click_button 'Add Tag!'
          page.should have_css('div.error', :text => 'Tag could not be added!')
        end
      end
    end
  end
end
