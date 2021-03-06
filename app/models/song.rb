class Song < ActiveRecord::Base
  before_destroy :destroy_ghost_tags

  belongs_to :session
  has_many :song_tags
  has_many :tags, through: :song_tags, dependent: :destroy

  has_many :comments, dependent: :destroy

  validates :file_name, format: {
    with: %r{\.(mp3|wav|flac)\Z}i,
    message: 'must be a mp3/wav/flac file.'
  }

  # Returns all songs ordered by the count of their tags
  # Default order is highest tag count to lowest
  scope :by_count_of_tags, lambda {
    includes([:session, :tags, :comments]).sort_by { |s| -s.tags.length }
  }

  # Returns all songs ordered by their session's session_date
  # Default order is oldest to newest
  scope :by_session_date, lambda {
    includes([:session, :tags, :comments]).sort_by { |s| s.session.session_date }
  }

  # Returns all songs ordered by their score
  # Default order is highest to lowest
  scope :by_score, lambda {
    includes([:session, :tags, :comments]).sort_by { |s| -s.score }
  }

  private

    def destroy_ghost_tags
      self.tags.each do |tag|
        tag.songs.delete(self)
        tag.destroy if tag.songs.empty?
      end
    end
end
