class PlansController < ApplicationController
  load_and_authorize_resource
  
  def index
    plans = Plan.all
    non_null_plans = plans.select { |p| p.time != nil }
    non_null_plans.sort! { |x,y| x.time <=> y.time }
    null_time_plans = plans.select { |p| p.time.nil? }
    @plans = non_null_plans.concat(null_time_plans)
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
    msg = 'That plan could not be found. It may have been deleted.'
    respond_to do |format|
      format.html { flash[:error] = msg; redirect_to plans_path }
      format.json { render :status => :not_found, :text => msg }
    end
  end
end
