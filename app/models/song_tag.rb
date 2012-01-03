class SongTag < ActiveRecord::Base
  
  validates :song_id, :presence => true
  validates :tag_id, :presence => true

  belongs_to :song
  belongs_to :tag

end
