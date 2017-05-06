class Shared_publication
	include Mongoid::Document
	belongs_to :user
	belongs_to :publication
	validates :publication, :presence => true
	validates :user, :presence => true
end
