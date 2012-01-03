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

class Song < ActiveRecord::Base
  belongs_to :session

  has_many :song_tags
  has_many :tags, :through => :song_tags

  validates :file_name, :presence => true
  validate :file_has_to_be_audio

  def add_tag(new_tag_name)
    tag = Tag.find_or_create_by_name(name: new_tag_name)
    song_tags.find_or_create_by_tag_id_and_song_id(tag.id,id)
  end

  def has_tag?(tag_name)
    tag = Tag.find_by_name(tag_name)
    return nil  if tag.nil?
    return true if song_tags.find_by_tag_id_and_song_id(tag.id, id)
  end

  private

    def file_has_to_be_audio
      unless ['mp3', 'flac','wav'].include? file_name.split(".").last.downcase
        errors.add(:file_name, "has to be mp3/flac/wav file")
      end
    end
end
