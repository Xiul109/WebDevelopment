class Publication
	include Mongoid::Document
	field :text, :type => String, :default => ""
	
	belongs_to :user
	has_many :likes
end
