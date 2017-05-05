class FriendshipsController < ApplicationController
	def deny
		if friendship=Friendship.find(params[:id]) and friendship.type=="unconfirmed"
			friendship2=Friendship.find_by(owner: friendship.friend, friend: friendship.owner)
			friendship.destroy
			friendship2.destroy
		else
			not_found
		end
		reload
	end
	
	def accept
		if friendship=Friendship.find(params[:id]) and friendship.type=="unconfirmed"
			friendship2=Friendship.find_by(owner: friendship.friend, friend: friendship.owner)
			friendship.update(type: "confirmed")
			friendship2.update(type: "confirmed")
		else
			not_found
		end
		reload
	end
	
	def revoke
		if friendship=Friendship.find(params[:id]) and friendship.type=="confirmed"
			friendship2=Friendship.find_by(owner: friendship.friend, friend: friendship.owner)
			friendship.destroy
			friendship2.destroy
		else
			not_found
		end
		reload
	end
end
