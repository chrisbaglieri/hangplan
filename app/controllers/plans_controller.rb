class PlansController < ApplicationController
  load_and_authorize_resource
  
  def index
    users = current_user.friends
    users << current_user
    @plans = Plan.where{{ user_id.in => users }}.page params[:page]
    respond_to do |format|
      format.html
      format.json do
        render :json => @plans.to_json(:include => { :owner => { :methods => :gravatar_id } })
      end
    end
  end
  
  def show
    @comment = Comment.new
    @comment.plan = @plan
    logger.debug(@comment.inspect)
    
    respond_to do |format|
      format.html
      format.json do
        render :json => @plan.to_json(:include => { :owner => { :methods => :gravatar_id } })
      end
    end
  end
  
  def new
    respond_with(@plan)
  end
  
  def create
    @plan.owner = current_user
    @plan.save
    respond_with(@plan)
  end
  
  def edit
    respond_with(@plan)
  end
  
  def update
    @plan.update_attributes(params[:plan])
    respond_with(@plan)
  end
  
  def destroy
    @plan.destroy
    respond_with(@plan, :location => :root)
  end
  
  rescue_from ActiveRecord::RecordNotFound do
    msg = "Well that's sad, it looks like the plan you're looking for is no longer happening."
    respond_to do |format|
      format.html { flash[:alert] = msg; redirect_to plans_path }
      format.json { render :json => msg, :status => :not_found }
    end
  end
end
