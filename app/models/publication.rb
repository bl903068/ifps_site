class Publication < ActiveRecord::Base
	attr_accessible :title, :ptype, :nameofpublication, :resume, :content

	belongs_to :user

	validates :title, presence: true, length: { maximum: 50 }
	validates :ptype, presence: true, length: { maximum: 50 }
	validates :nameofpublication, presence: true, length: { maximum: 50 }
	validates :resume, presence: true, length: { maximum: 140 }
	validates :content, presence: true
	validates :user_id, presence: true

	default_scope order: 'publications.created_at DESC'
end