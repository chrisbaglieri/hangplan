require 'spec_helper'

describe FriendshipsController do
  
  before(:each) do
    @user ||= Factory.create(:user)
    sign_in @user
  end

  describe "POST 'create'" do
    it "should be successful" do
      get 'create'
      response.should be_success
    end
  end

  describe "PUT 'approve'" do
    it "should be successful" do
      get 'approve'
      response.should be_success
    end
  end

  describe "DELETE 'destroy'" do
    it "should be successful" do
      get 'destroy'
      response.should be_success
    end
  end

end
