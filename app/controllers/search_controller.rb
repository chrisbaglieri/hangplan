class SearchController < ApplicationController

  def index
    q = params[:q]
    exp = "%#{q}%"
    @users = User.where("email LIKE ? OR name LIKE ?", exp, exp) if q
    respond_with(@users)
  end
end
