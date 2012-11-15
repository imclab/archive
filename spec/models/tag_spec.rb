require 'spec_helper'

describe Tag do
  describe 'validations' do
    it 'should not be valid with a blank name' do
      Tag.new(name: "").should_not be_valid
    end

    it 'should not be valid with a name too long' do
      Tag.new(name: 'a' * 21).should_not be_valid
    end

    it 'should have an unique name' do
      valid_tag   = Tag.create!(name: 'great')
      invalid_tag = Tag.new(name: 'great')
      invalid_tag.should_not be_valid
    end
  end

  describe '.all_associated_with_songs' do
    it 'should return all tags associated with songs when called' do
      tag  = Tag.create!(name: 'great')
      song = Song.create!(file_name: '01.testing.mp3')
      song.tags << tag

      tag_not_associated = Tag.create!(name: 'notassociated')

      associated = Tag.all_associated_with_songs
      associated.should include(tag)
      associated.should_not include(tag_not_associated)
    end
  end
end
