class UsersController < ApplicationController

  # GET /users/1
  # GET /users/1.json
  def show
    if params[:id]
      @user = User.find(params[:id])
    else
      @user = current_user
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end
end
