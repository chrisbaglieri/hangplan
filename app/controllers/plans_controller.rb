class PlansController < ApplicationController
  load_and_authorize_resource
  
  def index
    @filter ||= params[:filter] 
    case @filter
    when "tentative"
      @plans = Plan.unconfirmed
    when "1week" # out a week
      @plans = Plan.on_or_after(DateTime.now).on_or_before(1.week.from_now)
    when "2weeks" # out two weeks
      @plans = Plan.on_or_after(DateTime.now).on_or_before(2.weeks.from_now)
    when "1month" # out a month
      @plans = Plan.on_or_after(DateTime.now).on_or_before(1.month.from_now)
    else # all future
      @plans = Plan.on_or_after(DateTime.now)
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
