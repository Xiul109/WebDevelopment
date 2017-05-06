class Likes
	include Mongoid::Document
	belongs_to :user
	has_one :publication
end
