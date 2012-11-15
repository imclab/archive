require 'spec_helper'

describe SongTag do
  describe 'validations' do
    it 'should require a song_id' do
      SongTag.new(song_id: nil).should have(1).error_on(:song_id)
    end

    it 'should require a tag_id' do
      SongTag.new(tag_id: nil).should have(1).error_on(:tag_id)
    end
  end
end
