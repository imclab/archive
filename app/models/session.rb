# == Schema Information
#
# Table name: sessions
#
#  id           :integer         not null, primary key
#  session_date :date
#  created_at   :datetime
#  updated_at   :datetime
#

class Session < ActiveRecord::Base
  has_many :songs, :order => "file_name", :dependent => :destroy

  validates :session_date, :presence => true
  validates_associated :songs

  # Returns all sessions ordered by their session_date
  # Default order is oldest to newest
  def self.by_session_date
    order("session_date")
  end
end
