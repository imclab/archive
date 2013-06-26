class Tag < ActiveRecord::Base
  has_many :song_tags
  has_many :songs, through: :song_tags

  validates :name, presence: true, length: { maximum: 20 }
  validates_uniqueness_of :name

  default_scope -> { order('tags.name ASC') }

  def self.all_associated_with_songs
    SongTag.all.map { |st| Tag.find(st.tag_id) if Song.find(st.song_id) }.uniq
  end
end
