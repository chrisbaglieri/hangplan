class ParticipantsController < ApplicationController
  load_and_authorize_resource

  def create
    @participant.user = current_user
    @participant.plan = Plan.find_by_id(params[:plan_id])
    @participant.save
    respond_with(@participant)
  end

  def update
    @participant.save
    respond_with(@participant)
  end

  def destroy
    @participant.destroy
    respond_with(@participant, participants_url)
  end
end
