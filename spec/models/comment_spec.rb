require 'spec_helper'

describe Comment do
  describe "validation" do
    it "should not be valid with blank text" do
      invalid_comment = Comment.new(text: "")
      invalid_comment.should_not be_valid
      invalid_comment.should have(1).error_on(:text)
    end

    it "should not be valid with too much text" do
      long_text = "a" * 501
      invalid_comment = Comment.new(text: long_text)
      invalid_comment.should_not be_valid
    end
  end

  describe "associations with song and user models" do
    it "should respond with the right models" do
      song = Song.create!(file_name: "01.testing.mp3")
      user = User.create!(
        name: "The Stig",
        email: "stig@topgear.co.uk",
        password: "foobar",
        password_confirmation: "foobar"
      )
      comment = Comment.create!(song: song, user: user, text: "this rocks")

      comment.song.should == song
      comment.user.should == user
      user.comments.last.should == comment
      song.comments.last.should == comment
    end
  end
end
