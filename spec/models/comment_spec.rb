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

  describe "association with user model" do
    before(:each) do
      @user = User.create!(name: "The Stig", email: "stig@topgear.co.uk",
                           password: "foobar", password_confirmation: "foobar")
    end

    it "should respond with the right user model" do
      comment = Comment.create!(user_id: @user.id, text: "Stig was here")
      comment.user.should == @user
    end
  end

  describe "association with song model" do
    before(:each) do
      @song = Song.create!(file_name: "01.testing.mp3")
    end

    it "should respond with the right song model" do
      comment = Comment.create!(song_id: @song.id, text: "Stig was here")
      comment.song.should == @song
    end
  end

  describe "associations with song and user models" do
    before(:each) do
      @song = Song.create!(file_name: "01.testing.mp3")
      @user = User.create!(name: "The Stig", email: "stig@topgear.co.uk",
                           password: "foobar", password_confirmation: "foobar")
    end

    it "should respond with the right models" do
      comment = Comment.create!(song_id: @song.id, user_id: @user.id,
                                text: "My name is the stig, this song rocks")
      comment.song.should == @song
      comment.user.should == @user
      @user.comments.last.should == comment
      @song.comments.last.should == comment
    end
  end
end
