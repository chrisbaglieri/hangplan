class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :detect_mobile_key
  before_filter :set_time_zone
  
  respond_to :html, :json
  
  def after_sign_in_path_for(resource)
    plans_url
  end
  
  private
  
  def detect_mobile_key
    if params[:mobile_key] && (u = User.find_by_mobile_key(params[:mobile_key]))
      sign_in u
      logger.debug "signed in #{u.email}"
    end
  end
  
  def set_time_zone
    # TODO: Detect user's time zone, probably using the geocoder or something.
    Time.zone = "Eastern Time (US & Canada)"
  end
end
