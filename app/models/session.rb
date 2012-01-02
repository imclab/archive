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
  has_many :songs, :order => "file_name"

  validates :session_date, :presence => true
  validates_associated :songs
end
