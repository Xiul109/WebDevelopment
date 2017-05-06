class Likes
	include Mongoid::Document
	has_one :user
	belongs_to :publication
end
