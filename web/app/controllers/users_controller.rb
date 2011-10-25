class UsersController < ApplicationController
  load_and_authorize_resource
  
  def show
    @user ||= current_user
    respond_with(@user)
  end
end
