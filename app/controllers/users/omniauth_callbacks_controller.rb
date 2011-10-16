class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  
  def facebook
    @user = User.find_for_facebook_oauth(env['omniauth.auth'], current_user)
    
    if @user.persisted?
      flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', :kind => "Facebook"
      respond_to do |format|
        format.html { sign_in_and_redirect @user, :event => :authentication }
        format.json do
          @user.generate_mobile_key!
          render :json => @user
        end
      end
    else
      session['devise.facebook_data'] = env['omniauth.auth']
      respond_to do |format|
        format.html { redirect_to new_user_registration_url }
        format.json do
          render :status => 401 
        end
     end
    end
  end
  
  def passthru
    render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end
end