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

    it "should have an unique name" do
      valid_tag = Tag.create(name: "great")
      invalid_tag = Tag.new(name: "great")
      invalid_tag.should_not be_valid
    end
  end

  describe "tagging songs" do

    before(:each) do
      @song = Song.create!(:file_name => "01.testing.mp3")
      :A
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

    it "should respond to a all_associated_with_songs method" do
      Tag.should respond_to(:all_associated_with_songs)
    end

    it "should return all tags associated with songs when called" do
      @song.song_tags.create(:tag_id => @tag)
      tag_not_associated = Tag.create!(name: "notassociated")

      Tag.all_associated_with_songs.should include(@tag)
      Tag.all_associated_with_songs.should_not include(tag_not_associated)
    end
  end
end
