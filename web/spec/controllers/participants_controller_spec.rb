require 'spec_helper'
include Devise::TestHelpers

describe ParticipantsController do

  before(:each) do
    @plan ||= Factory.create(:plan)
    @user ||= Factory.create(:user)
    sign_in @user
  end
  
  describe 'POST create' do
    it 'adds a participant to a plan' do
      post :create, :plan_id => @plan.id
      assigns(:participant).should_not be_nil
      assigns(:participant).should be_persisted
      assigns(:participant).user.should eq(@user)
      assigns(:participant).plan.should eq(@plan)
      @plan.participants.should include(assigns(:participant))
      response.should redirect_to(@plan)
      flash[:notice].should_not be_blank
    end

    it 'handles an invalid plan id' do
      post :create, :plan_id => 42
      assigns(:participant).should be_nil
      response.should redirect_to(plans_path)
      flash[:alert].should_not be_blank
    end
  end
  
  describe 'PUT update' do
    it 'updates a plan' do
      participant = Participant.new
      participant.plan = @plan
      participant.user = @user
      participant.save!

      put :update, :id => participant.id, :participant => { :points => 1 }
      assigns(:participant).should be_persisted
      assigns(:participant).points.should eq(1)
      response.should redirect_to(@plan)
      flash[:notice].should_not be_blank
    end
  end
  
  describe 'DELETE destroy' do
    it 'removes a participant from a plan' do
      participant = Participant.new
      participant.plan = @plan
      participant.user = @user
      participant.save!
      
      delete :destroy, :id => participant.id
      flash[:notice].should_not be_blank
      response.should redirect_to(@plan)
      Participant.find_by_id(participant.id).should be_nil
    end
  end

end

