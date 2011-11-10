class FriendshipsController < ApplicationController
  authorize_resource
  before_filter :load_friend, :except => [:index]
  before_filter :validate_involvement, :except => [:index, :create]
  
  def index
    @friends = current_user.friends
    respond_with(@friends)
  end
  
  def create
    current_user.invite @friend
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { render :json => { :success => true, :message => "Friendship request sent" } }
    end
  end

  def approve
    current_user.approve @friend
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { render :json => { :success => true, :message => "Friendship approved" } }
    end
  end

  def remove
    current_user.remove_friendship @friend
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
  
  def load_friend
    friendship = Friendship.new(params[:friendship])
    @friend = User.find(friendship.user)
    raise ActiveRecord::RecordNotFound unless friend
    @friend
  end
  
  def validate_involvement
    current_user.connected_with? @friend
  end
end
