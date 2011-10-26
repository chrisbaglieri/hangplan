class ParticipantsController < ApplicationController
  load_and_authorize_resource :participant
  load_and_authorize_resource :plan, :through => :participant

  def create
    @participant.user = current_user
    @participant.plan = @plan
    if @participant.plan.tentative
      @participant.points = 1
    end
    @participant.save
    flash[:notice] = t 'participants.message.create', :plan => @participant.plan.name
    respond_with(@participant.plan)
  end

  def update
    @participant.save
    respond_with(@plan)
  end

  def destroy
    @participant.destroy
    flash[:notice] = t 'participants.message.destroy', :plan => @participant.plan.name
    respond_with(@participant.plan)
  end
end
