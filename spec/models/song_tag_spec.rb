require 'spec_helper'

describe SongTag do

  describe "validations" do

    before(:each) do
      @song     = Song.create!(file_name: "01.testing.mp3")
      @tag      = Tag.create!(name: "great")
      @song_tag = SongTag.new(tag: @tag, song: @song)
    end

    it "should require a song_id" do
      @song_tag.song = nil
      @song_tag.should_not be_valid
    end

    it "should require a tag_id" do
      @song_tag.tag = nil
      @song_tag.should_not be_valid
    end
  end
end
