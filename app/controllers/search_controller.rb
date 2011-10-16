class SearchController < ApplicationController

  def index
    @query = params[:q]
    exp = "%#{@query}%"
    
    if @query
      @users = User.where("email LIKE ? OR name LIKE ?", exp, exp)    
      @plans = Plan.where("name LIKE ?", exp)
    end
    
    respond_with(@users)
  end
end
