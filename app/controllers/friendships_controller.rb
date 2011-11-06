class FriendshipsController < ApplicationController
  authorize_resource
  
  def index
    @friends = current_user.friends
    respond_with(@friends)
  end
  
  def create
    friend = load_friend(params)
    current_user.invite friend
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { render :json => { :success => true, :message => "Friendship request sent" } }
    end
  end

  def approve
    friend = load_friend(params)
    current_user.approve friend
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { render :json => { :success => true, :message => "Friendship approved" } }
    end
  end

  def remove
    friend = load_friend(params)
    current_user.remove_friendship friend
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { render :json => { :success => true, :message => "Friendship removed" } }
    end
  end
  
  rescue_from ActiveRecord::RecordNotFound do
    msg = "Sorry, no user found."
    respond_to do |format|
      format.html { flash[:alert] = msg; redirect_to :back }
      format.json { render :json => msg, :status => :not_found }
    end
  end
  
  private
  
  def load_friend(params)
    friendship = Friendship.new(params[:friendship])
    friend = User.find(friendship.user)
    raise ActiveRecord::RecordNotFound unless friend
    friend
  end
end
