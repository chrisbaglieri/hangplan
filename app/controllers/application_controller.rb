class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :detect_mobile_key
  
  respond_to :html, :json
  
  private
  
  def detect_mobile_key
    if params[:mobile_key] && (u = User.find_by_mobile_key(params[:mobile_key]))
      sign_in u
      logger.debug "signed in #{u.email}"
    end
  end
end
