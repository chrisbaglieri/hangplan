class UsersController < ApplicationController
  load_and_authorize_resource
  
  def show
    respond_with(@user)
  end
end
