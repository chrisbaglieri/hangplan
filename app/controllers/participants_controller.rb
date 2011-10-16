class ParticipantsController < ApplicationController

  # POST /participants
  # POST /participants.json
  def create
    @participant = Participant.new(params[:participant])
    @participant.user = current_user
    @participant.plan = Plan.find_by_id(params[:plan_id])

    respond_to do |format|
      if @participant.save
        format.html { redirect_to plans_path, notice: 'Participant was successfully created.' }
        format.json { render json: @participant, status: :created, location: @participant }
      else
        format.html { redirect_to plans_path, error: 'Error occurred during save.' }
        format.json { render json: @participant.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /participants/1
  # PUT /participants/1.json
  def update
    @participant = Participant.find(params[:id])

    respond_to do |format|
      if @participant.update_attributes(params[:participant])
        format.html { redirect_to @participant, notice: 'Participant was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @participant.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /participants/1
  # DELETE /participants/1.json
  def destroy
    @participant = Participant.find(params[:id])
    @participant.destroy

    respond_to do |format|
      format.html { redirect_to participants_url }
      format.json { head :ok }
    end
  end
end
