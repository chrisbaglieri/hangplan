class PlansController < ApplicationController
  load_and_authorize_resource
  
  def index
    filter ||= params[:filter] 
    case filter
    when "tenative"
      @plans = Plan.unconfirmed
    when "1week"
      @plans = Plan.starts_after(1.week.ago)
    when "2week"
      @plans = Plan.starts_after(2.weeks.ago)
    else # 1month
      @plans = Plan.starts_after(1.month.ago)
    end
    respond_to do |format|
      format.html
      format.json do
        render :json => @plans.to_json(:include => { :owner => { :methods => :gravatar_id } })
      end
    end
  end
  
  def show
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
