class FriendshipsController < ApplicationController
  authorize_resource
  
  def create
    friend = User.find(params[:user_id])
    current_user.invite(friend)
    redirect_to friendships_path
  end

  def approve
    friend = User.find(params[:user_id])
    current_user.approve(friend)
    redirect_to friendships_path
  end

  def destroy
    friend = User.find(params[:user_id])
    friendship = current_user.send(:find_any_friendship_with, friend)
    friendship.delete if friendship
    redirect_to friendships_path
  end
end
