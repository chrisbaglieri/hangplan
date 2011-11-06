require 'spec_helper'
include Devise::TestHelpers

describe NotificationsController do
  
  before(:each) do
    @user ||= Factory(:user)
    @another_user ||= Factory(:user)
  end
  
  describe "GET 'index'" do
    it "should show a user's invites" do
      @user.invite @another_user
      sign_in @user
      get :index
      assigns(:pending_invites).should have(1).things
      response.should be_success
      response.should render_template('index')
    end
    
    it "should show a friend's pending invites" do
      @user.invite @another_user
      sign_in @another_user
      get :index
      assigns(:pending_friend_invites).should have(1).things
      response.should be_success
      response.should render_template('index')
    end
  end

end
