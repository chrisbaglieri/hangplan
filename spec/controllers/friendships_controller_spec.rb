require 'spec_helper'
include Devise::TestHelpers

describe FriendshipsController do
  
  before(:each) do
    @user ||= Factory(:user)
    sign_in @user
  end
  
  describe "GET 'index'" do
    it "should succeed with no friends" do
      get :index
      response.should be_success
      response.should render_template('index')
    end
    
    it "should succeed with friends" do
      another_user = Factory(:user)
      @user.invite another_user
      another_user.approve @user
      get :index
      assigns(:friends).should include(another_user)
      response.should be_success
      response.should render_template('index')
    end
  end

  describe "POST 'create'" do
    it "should create a friend request" do
      another_user = Factory(:user)
      request.env["HTTP_REFERER"] = 'http://test.host/notifications'
      post :create, :friendship => { :user_id => another_user.id }
      @user.pending_invited.should include(another_user)
      another_user.pending_invited_by.should include(@user)
      response.should be_redirect
      response.should redirect_to('http://test.host/notifications')
    end
    
    it "should not create a friend request for a non-existant user (json)" do
      post :create, :friendship => { :user_id => 123456789 }, :format => :json
      response.code.should eq('404')
      response.body.should_not be_blank
    end
  end

  describe "PUT 'approve'" do
    it "should approve a friend request" do
      another_user = Factory(:user)
      another_user.invite @user
      request.env["HTTP_REFERER"] = 'http://test.host/notifications'
      put :approve, :friendship => { :user_id => another_user.id }
      @user.friends.should include(another_user)
      another_user.friends.should include(@user)
      response.should be_redirect
      response.should redirect_to('http://test.host/notifications')
    end
  end
  
  describe "DELETE 'remove'" do
    it "should remove a friendship" do
      another_user = Factory(:user)
      @user.invite another_user
      another_user.approve @user
      request.env["HTTP_REFERER"] = 'http://test.host/notifications'
      delete :remove, :friendship => { :user_id => another_user.id }
      @user.friends.should_not include(another_user)
      another_user.friends.should_not include(@user)
      response.should be_redirect
      response.should redirect_to('http://test.host/notifications')
    end
  end
end
