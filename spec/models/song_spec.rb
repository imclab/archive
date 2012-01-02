# == Schema Information
#
# Table name: songs
#
#  id         :integer         not null, primary key
#  file_name  :string(255)
#  session_id :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Song do
  before(:each) do
    @attr = { :file_name => "01.testing.mp3" }
  end

  it "should create a new instance given file_name" do
    Song.create!(@attr)
  end


  describe "should only take audio files as file_name" do

    it "should take a mp3/flac/wav file" do
      files = %w[testing.mp3 01.testing.mp3 testing.wav 01.testing.wav 
                testing.flac 01.testing.flac]
      files.each do |file|
        valid_file_song = Song.new(:file_name => file)
        valid_file_song.should be_valid
      end
    end

    it "should reject non-audio files" do
      files = %w[testing.jpg testing.bmp testing.txt testing.npr]
      files.each do |file|
        invalid_file_song = Song.new(:file_name => file)
        invalid_file_song.should_not be_valid
      end
    end
  end

end
