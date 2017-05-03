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
	def not_found
		raise ActionController::RoutingError.new('404 - Not Found')
	end
	
	def adminEdit
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
				if user_params[:password]==""
					User.update(params[:id], :name => user_params[:name], :bio => user_params[:bio],:email => user_params[:email])
				else
					User.update(params[:id], :name => user_params[:name], :bio => user_params[:bio],:email => user_params[:email] ,:encrypted_password => User.new(:password=>user_params[:password]).encrypted_password)
				end
			else
				flash.alert = "La contraseña no coincide con la confirmación"
			end
		else
			flash.alert = "No estás autorizado para modificar un usuario"
		end
	end
	
	def user_params
		params.require :user
	end
end
