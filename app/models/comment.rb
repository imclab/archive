class Comment < ActiveRecord::Base
  validates :text, presence: true, length: { maximum: 500 }
  belongs_to :user
  belongs_to :song
end
