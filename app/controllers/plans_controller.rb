class PlansController < ApplicationController
  load_and_authorize_resource
  
  def index
    @plans = Plans.all
    @plans.sort! { |x,y| x.time <=> y.time }
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
    respond_with(@plan, :root)
  end
end
