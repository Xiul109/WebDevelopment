class Publication
	include Mongoid::Document
	field :text, :type => String, :default => ""
	field :image, :type =>String
	
	belongs_to :user
	has_many :likes
end
