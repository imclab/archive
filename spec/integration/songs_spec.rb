require 'spec_helper'

describe "Songs" do
  describe "GET 'index'" do
    it "should show a songs list" do
      @song = Song.create!(file_name: "01.testing.mp3")

      visit '/songs'

      current_path.should == songs_path
      page.should have_css("title", :title => "Howling Vibes Archive | All songs")
      page.should have_css("ul.song-list")
      page.should have_link(@song.file_name, :href => song_path(@song))
    end

    describe "clicking on the 'Show' links" do
      before(:each) do
        @old_session = Session.create!(session_date: Time.now - 2.days)
        @old_song = @old_session.songs.create!(file_name: "01.breaking.bad.mp3")

        @new_session = Session.create!(session_date: Time.now)
        @new_song = @new_session.songs.create!(file_name: "01.hello_joe.mp3")
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

      it "should show the song with the highest score when clicked on 'Highest Score'" do
        @old_song.score = 50
        @old_song.save
        @new_song.score = 80
        @new_song.save

        visit '/songs/'
        click_link "Highest Score"

        page.body.should =~ /#{@new_song.file_name}.*#{@old_song.file_name}/m
      end
    end
  end

  describe "GET 'show'" do
    before(:each) do
      @session = Session.create!(session_date: Time.parse("2012.03.26"))
      @song = @session.songs.create!(file_name: "01.breaking.bad.mp3")
    end

    it "shows the session date of the song" do
      visit song_path(@song)
      # Timezone issues here...
      page.should have_css('span.recorded-at', text: '2012.03.25')
    end

    it "shows a message if no comments are added" do
      visit song_path(@song)

      page.should have_css('span.no-comments', text: 'This song has no comments, add some!')
    end

    it "shows the associated comments" do
      user = create_user
      comment = Comment.create!(
        song_id: @song.id,
        user_id: user.id,
        text: "This is a test comment"
      )

      visit song_path(@song)

      page.should have_css('p', text: "This is a test comment")
    end

    it "shows a message if no tags are associated" do
      visit song_path(@song)

      page.should have_css('span.no-tags', :text => 'This song has no tags!')
    end

    it "shows the associated tags" do
      @song.add_tag('great')

      visit song_path(@song)

      page.should have_css('span.tag', :text => 'great')
    end

    context "as logged-in user" do
      before(:each) do
        create_user # Name: johnny
        integration_sign_in
      end

      describe "song tags" do
        describe "adding tags via form" do
          it "adds a tag when submitted via form and display it" do
            visit song_path(@song)

            fill_in "tag[name]", :with => 'superduper'
            click_button 'Add Tag!'

            page.should have_css('div.success', :text => 'Tag "superduper" saved!')
            page.should have_css('span.tag', :text => 'superduper')
          end

          it "prints an error message when empty field was submitted" do
            visit song_path(@song)
            # No filling here
            click_button 'Add Tag!'

            page.should have_css('div.error', :text => 'Tag could not be added!')
          end
        end
      end
      describe "song commments" do
        describe "adding comments via form" do
          it "adds a comment when submitted via form and display it" do
            visit song_path(@song)

            fill_in "comment[text]", :with => 'This is a test comment'
            click_button 'Add Comment!'

            page.should have_css('div.success', :text => 'You successfully added a comment!')
            page.should have_css('p', :text => 'This is a test comment')
          end

          it "prints an error message when empty form was submitted" do
            visit song_path(@song)

            click_button 'Add Comment!'

            page.should have_css('div.error', :text => 'Comment could not be added!')
          end
        end

        describe 'deleting your own comments' do
          it 'allows users to delete their own comments' do
            visit song_path(@song)

            fill_in "comment[text]", :with => 'This is going to be deleted'
            click_button 'Add Comment!'

            click_link 'Delete this comment'

            page.should have_css('div.notification', text: 'You successfully deleted a comment!')
            page.should_not have_css('p', text: 'This is going to be deleted')
          end

          it 'does not allow users to delete comments of other users' do
            other_user = User.create!(
              email: 'theother@user.com',
              name: 'dontknowme',
              password: 'notimportant'
            )
            comment = Comment.create!(
              song_id: @song.id,
              user_id: other_user.id,
              text: 'Cant touch this!'
            )

            visit song_path(@song)

            page.should have_content('Cant touch this!')
            page.should_not have_content('Delete this comment')
          end
        end
      end
    end

    describe "as not-logged-in user" do
      it "does not show the form to add tags" do
        visit song_path(@song)
        page.should_not have_css('form.new_tag')
      end

      it "does not show the form to add comments" do
        visit song_path(@song)
        page.should_not have_css('form.new_comment')
      end
    end
  end
end