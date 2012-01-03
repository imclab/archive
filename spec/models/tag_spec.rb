require 'spec_helper'

describe Tag do

  describe "validation" do
    it "should create a new instance given file_name" do
      Tag.create!(name: "magnificient")
    end

    it "should not be valid with a blank name" do
      invalid_tag = Tag.new(name: "")
      invalid_tag.should_not be_valid
    end

    it "should not be valid with a name too long" do
      long_tag_name = "a" * 21
      invalid_tag = Tag.new(name: long_tag_name)
      invalid_tag.should_not be_valid
    end
  end

  describe "tagging songs" do

    before(:each) do
      @song = Song.create!(:file_name => "01.testing.mp3")
      @tag = Tag.create!(:name => "great")
    end

    it "should respond to a song_tags method" do
      @tag.should respond_to(:song_tags)
    end

    it "should rspond to a songs method" do
      @tag.should respond_to(:songs)
    end

    it "should show the song being attached to" do
      @song.song_tags.create(:tag_id => @tag)
      @tag.songs.find(@song).should == @song
    end
  end
end
