class Session < ActiveRecord::Base
  has_many :songs, -> { order('file_name') }, dependent: :destroy

  validates :session_date, presence: true
  validates_associated :songs

  scope :by_session_date, lambda {
    includes(songs: [:comments, :tags]).order('session_date')
  }
end
