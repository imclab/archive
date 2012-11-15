class Session < ActiveRecord::Base
  has_many :songs, order: 'file_name', dependent: :destroy

  validates :session_date, presence: true
  validates_associated :songs

  def self.by_session_date
    includes(songs: [:comments, :tags]).order('session_date')
  end
end
