class SubscriptionsController < ApplicationController
  load_and_authorize_resource
  
  def new
    respond_with(@subscription)
  end
  
  def create 
    email = params[:email]
    u = User.find_by_email(email)
    if u && !u.invited?
      @subscription.user = current_user
      @subscription.followed_user = u
      flash[:notice] = "You have subscribed to #{u.name}."
      redirect_to root_path
    else
      User.invite!(:email => email)
      flash[:notice] = "An invitation has been sent to #{email}."
      redirect_to root_path
    end
  end
end
