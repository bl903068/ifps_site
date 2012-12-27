class User < ActiveRecord::Base
	attr_accessible :name, :first_name, :labo ,:email, :password, :password_confirmation
	has_secure_password

	before_save { |user| user.email = email.downcase }

	validates :name, presence: true, length: { maximum: 50 }
	validates :first_name, presence: true, length: { maximum: 50 }
	validates :labo, presence: true, length: { maximum: 100 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
	validates :password, presence: true, length: { minimum: 8 }
	validates :password_confirmation, presence: true
end
