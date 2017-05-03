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
					redirect_to users_path
				else
					not_found
				end
			else
				flash.alert = "The passwords doesn't match"
				redirect_to :back
			end
		else
			not_autorized
			redirect_to :back
		end
	end
	
	def delete
		if current_user.role=="admin"
			if @user=User.find(params[:id])
				@user.destroy
			else
				not_found
			end
		else
			not_autorized
		end
	end
	
	def promote
		if current_user.role=="admin"
			if @user=User.find(params[:id])
				@user.update(role: "admin")
			else
				not_found
			end
		else
			not_autorized
		end
	end

	#Aux functions
	def user_params
		params.require :user
	end
	
	def not_autorized
		flash.alert = "You are not autorized"
	end
	
	def not_found
		raise ActionController::RoutingError.new('404 - Not Found')
	end
end
