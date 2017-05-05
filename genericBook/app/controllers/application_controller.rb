class ApplicationController < ActionController::Base
#  protect_from_forgery with: :exception
	before_action :authenticate_user!
	before_action :getFriendshipPetitions
	
	#AUX functions
	def queryFriends(type=nil)
		if !type
			current_user.friendships
		else
			current_user.friendships.where(type: type)
		end
	end
	
	def getFriendshipPetitions
		@unconfirmedFriends=queryFriends "unconfirmed"
	end
	
	def reload
		redirect_back(fallback_location: root_path)
	end
	
	def not_autorized
		flash.alert = "You are not autorized"
	end
	
	def not_found
		raise ActionController::RoutingError.new('404 - Not Found')
	end
end
