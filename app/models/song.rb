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

  private

    def file_has_to_be_audio
      unless ['mp3', 'flac','wav'].include? file_name.split(".").last.downcase
        errors.add(:file_name, "has to be mp3/flac/wav file")
      end
    end
end
