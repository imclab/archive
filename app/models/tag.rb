class Tag < ActiveRecord::Base
  has_many :song_tags
  has_many :songs, :through => :song_tags

  validates :name, :presence => true, 
                   :length   => { :maximum => 20 }
end
