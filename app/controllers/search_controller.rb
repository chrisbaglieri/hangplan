class SearchController < ApplicationController

  def index
    @query = params[:q]
    exp = "%#{@query}%"
    
    if @query
      @users = User.where("email LIKE ? OR name LIKE ?", exp, exp).limit(5)
      @users.delete_if { |u| u.email == current_user.email}
      @plans = Plan.where("name LIKE ?", exp).limit(5)
    end
    
    respond_with(@users)
  end
end
