require 'spec_helper'

describe Song do

  it "should create a new instance given file_name" do
    Song.create!(file_name: "01.testing.mp3")
  end


  describe "file_name validations" do

    it "should take a mp3/flac/wav file" do
      files = %w[testing.mp3 01.testing.mp3 testing.wav 01.testing.wav 
                testing.flac 01.testing.flac]
      files.each do |file|
        Song.new(:file_name => file).should be_valid
      end
    end

    it "should reject non-audio files" do
      files = %w[testing.jpg testing.bmp testing.txt testing.npr]
      files.each do |file|
        Song.new(:file_name => file).should_not be_valid
      end
    end
  end
  
  describe "comment associations" do
    before(:each) do
      @song = Song.create!(file_name: "01.testing.mp3")
    end

    it "should respond to :comments" do
      @song.should respond_to(:comments)
    end

    it "should show the right comments" do
      comment_one = Comment.create!(song: @song, text: "This rocks")
      comment_two = Comment.create!(song: @song, text: "This is cool")
      @song.comments.should == [comment_one, comment_two]
    end
  end

  describe "tag associations" do
    
    before(:each) do
      @song = Song.create!(:file_name => "01.testing.mp3")
      @tag  = Tag.create!(:name => "great!")
    end

    it "should have a song_tags method" do
      @song.should respond_to(:song_tags)
    end

    it "should have a tags method" do
      @song.should respond_to(:tags)
    end

    it "should show the right tag" do
      @song.tags << @tag
      @song.tags.find(@tag).should == @tag
    end

    it "should have an add_tag method" do
      @song.should respond_to(:add_tag)
    end

    it "should get tag via add_tag method" do
      @song.add_tag("great!")
      @song.should have_tag("great!")
    end

    it "should show tags sorted by name" do
      tag1 = Tag.create!(:name => "zzz")
      tag2 = Tag.create!(:name => "awesome")
      @song.tags << [tag1, tag2]
      @song.tags.should == [tag2, tag1] 
    end

    it "should not have duplicates of a tag" do
      @song.add_tag("great!")
      @song.add_tag("great!")
      @song.tags.where(name: "great!").count.should eql(1)
    end

    it "should be possible for two files to have the same tag" do
      @song.add_tag("great!")
      @song2 = Song.create!(file_name: "02.testing.mp3")
      @song2.add_tag("great!")
      @song.should have_tag("great!")
      @song2.should have_tag("great!")
    end

    it "should delete SongTags association when deleted" do
      @song.tags << @tag
      lambda do
        @song.destroy
      end.should change(SongTag, :count).by(-1)
    end

    it "should delete tags that are only associated with this song" do
      @song.tags << @tag
      song2 = Song.create!(file_name: "02.different_song.mp3")
      tag2 = Tag.create!(name: "differenttag")
      song2.tags << tag2
      lambda do
        @song.destroy
      end.should change(Tag, :count).by(-1)
    end
  end

  describe "ordering" do
    before(:each) do
      @song = Song.create!(file_name: "01.most_tagged_song_(RMX).mp3")
      @song2 = Song.create!(file_name: "02.indie_song.mp3")
    end

    it "should respond to and have working 'by_count_of_tags' method" do
      @song.tags.create!(name: "brbrbrilliant")
      @song.tags.create!(name: "sellout")
      @song2.tags.create!(name: "sensibel")

      Song.by_count_of_tags.should == [@song, @song2]
    end

    it "should respond to and have working 'by_session_date' method" do
      @session = Session.create!(session_date: Time.now)
      @session.songs << @song

      @session2 = Session.create!(session_date: Time.now - 1.day)
      @session2.songs << @song2

      Song.by_session_date.should == [@song2, @song]
    end

    it "should respond to and have working 'by_score' method" do
      @song.score = 10
      @song.save
      @song2.score = 90
      @song2.save

      Song.by_score.should == [@song2, @song]
    end
  end
end
