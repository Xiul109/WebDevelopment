class Friendship
	include Mongoid::Document
	belongs_to :owner, :class_name =>"User", inverse_of: :friendships
	belongs_to :friend, :class_name=>"User"
	field :type, :type => String, :default => "pending"
end
