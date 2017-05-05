class UsersController < ApplicationController
	def index
		@friends=queryFriends
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
		if @user=User.find(params[:id])
			friendship1=Friendship.new
			friendship1.owner=current_user
			friendship1.friend=@user
			friendship1.save
		
			friendship2=Friendship.new
			friendship2.owner=@user
			friendship2.friend=current_user
			friendship2.type= "unconfirmed"
			friendship2.save
			flash.notice = "The petition has been sended"
		else
			not_found
		end
		reload
	end

	#Aux functions
	def confirmFriend user, friend
		f1=user.friendships.find(friend: friend)
		f1.type="confirmed"
		
		f2=friend.friendships.find(friend: user)
		f2.type="confirmed"
	end
	def user_params
		params.require :user
	end
end
