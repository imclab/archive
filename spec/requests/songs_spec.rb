require 'spec_helper'

describe "Songs" do

  describe "GET 'index'" do
    it "should have the right title" do
      visit '/songs'
      current_path.should == songs_path
      page.should have_css("title",
                           :title => "Howling Vibes Archive | All songs")
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
                             :text => 'This song has no tags! Add some!')
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
