class PlansController < ApplicationController
  load_and_authorize_resource
  
  def index
    @plans = Plan.all
    respond_with(@plans)
  end
  
  def show
    respond_with(@plan)
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
