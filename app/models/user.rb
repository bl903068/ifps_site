class User < ActiveRecord::Base
	attr_accessible :name, :first_name, :labo ,:email, :password, :password_confirmation
	has_secure_password
	has_many :publications, dependent: :destroy
	has_many :relationships, foreign_key: "follower_id", dependent: :destroy
	has_many :followed_publications, through: :relationships, source: :followed

	before_save { |user| user.email = email.downcase }
	before_save :create_remember_token

	validates :name, presence: true, length: { maximum: 50 }
	validates :first_name, presence: true, length: { maximum: 50 }
	validates :labo, presence: true, length: { maximum: 100 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
	validates :password, presence: true, length: { minimum: 8 }
	validates :password_confirmation, presence: true

	def feed
		Publication.where("user_id = ?", id)
	end

	def following?(other_publication)
		relationships.find_by_followed_id(other_publication.id)
	end

	def follow!(other_publication)
		relationships.create!(followed_id: other_publication.id)
	end

	def unfollow!(other_publication)
		relationships.find_by_followed_id(other_publication.id).destroy
	end

	private

		def create_remember_token
			self.remember_token = SecureRandom.urlsafe_base64
		end
end
