class ParticipantsController < ApplicationController
  load_and_authorize_resource :plan
  load_and_authorize_resource :participant, :through => :plan, :shallow => true

  def create
    @participant.user = current_user
    if @participant.plan.tentative
      @participant.points = 1
    end
    @participant.save
    respond_with(@participant.plan)
  end

  def update
    @participant.update_attributes(params[:participant])
    respond_with(@participant.plan)
  end

  def destroy
    @participant.destroy
    respond_with(@participant.plan)
  end

  rescue_from ActiveRecord::RecordNotFound do
    msg = t('participants.message.notfound')
    respond_to do |format|
      format.html { flash[:alert] = msg; redirect_to plans_path }
      format.json { render :json => msg, :status => :not_found }
    end
  end

end
