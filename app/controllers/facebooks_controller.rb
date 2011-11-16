class FacebooksController < ApplicationController  
  def new
    client = Facebook.authenticate(callback_facebook_url).client
    redirect_to client.authorization_uri(:scope => Facebook.config[:scope])
  end

  def create
    client = Facebook.authenticate(callback_facebook_url).client
    client.authorization_code = params[:code]
    rack_access_token = client.access_token!
    access_token = rack_access_token.access_token
    fb_user = FbGraph::User.me(access_token).fetch
    user = Facebook.find_or_create_user(fb_user)
    identity = user.facebook
    unless identity
      identity = Facebook.new
      identity.user = user
      identity.identifier = user.email
    end
    identity.access_token = access_token
    identity.save
    sign_in user
    redirect_to root_url
  end
end