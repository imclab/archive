require 'spec_helper'

describe Song do
  describe 'file_name validations' do
    it 'should take a mp3/flac/wav file' do
      files = %w[testing.mp3 01.testing.mp3 testing.wav 01.testing.wav testing.flac 01.testing.flac]
      files.each { |file| Song.new(file_name: file).should be_valid }
    end

    it 'should reject non-audio files' do
      files = %w[testing.jpg testing.bmp testing.txt testing.npr]
      files.each { |file| Song.new(file_name: file).should_not be_valid }
    end
  end

  describe 'tag associations' do
    before(:each) do
      @song = Song.create!(file_name: '01.testing.mp3')
      @tag  = Tag.create!(name: 'great!')
    end

    it 'should show tags sorted by name' do
      ztag = Tag.create!(name: 'zzz')
      @song.tags << [@tag, ztag]
      @song.tags.should == [@tag, ztag]
    end

    it 'should be possible for two files to have the same tag' do
      song2 = Song.create!(file_name: '02.testing.mp3')

      @song.tags << @tag
      song2.tags << @tag

      @song.tags.last.name.should == 'great!'
      song2.tags.last.name.should == 'great!'
    end

    it 'should delete SongTags association when deleted' do
      @song.tags << @tag

      lambda do
        @song.destroy
      end.should change(SongTag, :count).by(-1)
    end

    it 'should delete tags that are only associated with this song' do
      @song.tags << @tag

      song2 = Song.create!(file_name: '02.different_song.mp3')
      tag2  = Tag.create!(name: 'differenttag')
      song2.tags << tag2

      lambda do
        @song.destroy
      end.should change(Tag, :count).by(-1)
    end
  end

  describe 'ordering' do
    before(:each) do
      @song  = Song.create!(file_name: '01.most_tagged_song_(RMX).mp3')
      @song2 = Song.create!(file_name: '02.indie_song.mp3')
    end

    it 'should respond to and have working by_count_of_tags method' do
      @song.tags.create!(name: 'brbrbrilliant')
      @song.tags.create!(name: 'sellout')

      @song2.tags.create!(name: 'sensibel')

      Song.by_count_of_tags.should == [@song, @song2]
    end

    it 'should respond to and have working by_session_date method' do
      @session = Session.create!(session_date: Time.now)
      @session.songs << @song

      @session2 = Session.create!(session_date: 1.day.ago)
      @session2.songs << @song2

      Song.by_session_date.should == [@song2, @song]
    end

    it 'should respond to and have working by_score method' do
      @song.update_attribute(:score, 10)

      @song2.update_attribute(:score, 90)

      Song.by_score.should == [@song2, @song]
    end
  end
end
