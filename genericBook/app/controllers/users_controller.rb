class UsersController < ApplicationController
	def index
		queryFriends
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
		end
	end
	
	def edit
		if current_user.role!="admin"
			not_found
		elsif params[:id]
			if !@user=User.find(:id=>params[:id])
				not_found
			end
		end
	end
	
	def update
		if current_user.role=="admin"
			if user_params[:password]==user_params[:password_confirmation]
				if @user=User.find(id: params[:id])
					if user_params[:password]==""
						@user.update(:name => user_params[:name], :bio => user_params[:bio],:email => user_params[:email])
					else
						@user.update(:name => user_params[:name], :bio => user_params[:bio],:email => user_params[:email] ,:encrypted_password => User.new(:password=>user_params[:password]).encrypted_password)
					end
					flash.notice = "The update has been succesful"
				else
					not_found
				end
			else
				flash.alert = "The passwords doesn't match"
			end
		else
			not_autorized
		end
		reload
	end
	
	def delete
		if current_user.role=="admin"
			if @user=User.find(params[:id])
				@user.destroy
				flash.notice = "The deletion has been succesful"
			else
				not_found
			end
		else
			not_autorized
		end
		reload
	end
	
	def promote
		if current_user.role=="admin"
			if @user=User.find(params[:id])
				@user.update(role: "admin")
				flash.notice = "The promotion has been succesful"
			else
				not_found
			end
		else
			not_autorized
		end
		reload
	end
	
	def addFriend
		#Cambiar params y hacer comprobaciones y añadir amistad también al otro usuario
		@f=Friendship.new
		@friendship.owner=current_user
		@friendship.friend=User.find(params[:id])
		@friendship.save
		flash.notice = "The petition has been sended"
		reload
	end

	#Aux functions
	def reload
		redirect_back(fallback_location: root_path)
	end
	def user_params
		params.require :user
	end
	
	def not_autorized
		flash.alert = "You are not autorized"
	end
	
	def queryFriends(type=nil)
		if !type
			@friends=current_user.friendships
		else
			@friends=current_user.friendships.where(type: type)
		end
	end
	
	def not_found
		raise ActionController::RoutingError.new('404 - Not Found')
	end
end
