require 'spec_helper'

describe SongTag do

  before(:each) do
    @song = Song.create(:file_name => "01.testing.mp3")
    @tag = Tag.create(:name => "great")

    @song_tag = @song.song_tags.build(:tag_id => @tag.id)
  end

  it "should create a new instance given valid attributes" do
    @song_tag.save!
  end

  describe "validations" do

    it "should require a song_id" do
      @song_tag.song_id = nil
      @song_tag.should_not be_valid
    end

    it "should require a tag_id" do
      @song_tag.tag_id = nil
      @song_tag.should_not be_valid
    end
  end

  describe "song and tag methods" do

    it "should have a song attribute" do
      @song_tag.should respond_to(:song)
    end

    it "should have the right song" do
      @song_tag.song.should == @song
    end

    it "should have a tag attribute" do
      @song_tag.should respond_to(:tag)
    end

    it "should have the right tag" do
      @song_tag.tag.should == @tag
    end
  end
end
