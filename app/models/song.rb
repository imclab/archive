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
  has_many :tags, through: :song_tags

  validates :file_name, presence: true, format: {
    with: %r{\.(mp3|wav|flac)$}i,
    message: 'must be a mp3/wav/flac file.'
  }

  def add_tag(new_tag_name)
    tag = Tag.find_or_create_by_name(name: new_tag_name)
    song_tags.find_or_create_by_tag_id_and_song_id(tag.id,id)
  end

  def has_tag?(tag_name)
    tag = Tag.find_by_name(tag_name)
    tag.present? && song_tags.find_by_tag_id_and_song_id(tag.id, id).present?
  end
end
