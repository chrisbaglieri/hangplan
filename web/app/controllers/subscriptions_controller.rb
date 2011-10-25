class SubscriptionsController < ApplicationController
  load_and_authorize_resource
  
  def new
    respond_with(@subscription)
  end
  
  def create 
    email = params[:email]
    u = User.find_by_email(email) if email
    if email && (!u || u.invited?)
      User.invite!(:email => email)
      flash[:notice] = "An invitation has been sent to #{email}."
      redirect_to plans_path
    end
    
    u ||= User.find_by_id(params[:id]) if params[:id]
    @subscription.user = current_user
    @subscription.followed_user = u
    if Subscription.find_by_user_id_and_followed_user_id(current_user, u)
      flash[:notice] = "Already subscribed to #{u.name}."
    elsif @subscription.save
      flash[:notice] = "You have subscribed to #{u.name}."
    else 
      flash[:error] = "Error while subscribing to #{u.name}."
    end
    redirect_to plans_path
  end
end
