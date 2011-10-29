require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  protect_from_forgery
  before_filter :set_time_zone
  before_filter :ensure_domain
  respond_to :html, :json
  
  def after_sign_in_path_for(resource)
    plans_url
  end
  
  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { render :file => "#{Rails.root}/public/403.html", :status => :forbidden }
      format.json { render :json => "Access denied", :status => :forbidden }
    end
  end
  
  private
  
  def set_time_zone
    Time.zone = "Eastern Time (US & Canada)"
  end
  
  def ensure_domain
    if request.host.downcase == "hangplan.com"
      redirect_to "http://www.hangplan.com"
    end
  end
  
end