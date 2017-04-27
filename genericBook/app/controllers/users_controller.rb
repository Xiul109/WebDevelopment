class UsersController < ApplicationController
	before_action :authenticate_user!
	def index
		if current_user.role=="admin"
			@users=User.where(:id.ne=>current_user.id)
		else
			@users = User.where(:role.ne=>"admin",:id.ne=>current_user.id)
		end
	end
	
	def profile
		if params[:id]
			if !@user=User.find(:id=>params[:id])
				not_found
			end
		else
			@user=current_user
		end
	end
	def not_found
		raise ActionController::RoutingError.new('Not Found')#Change not found
	end
end
