class User < ActiveRecord::Base
  # attr_accessible :email, :name, :password, :password_confirmation
  has_secure_password

  validates :name, presence: true,
                   length: { maximum: 30 }

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, format: { with: email_regex},
                    uniqueness: { case_sensitive: false }

  validates :password, presence: { on: :create },
                       length: { within: 6..40 }

  has_many :comments
end
