class FacebookAuthenticationsController < ApplicationController
  skip_before_filter :require_authentication
  
  # handle Normal OAuth flow: start
  def new
    redirect_to FacebookAuthentication.authorize_url(:redirect_uri => callback_facebook_authentications_url, 
                                                     :scope => FacebookAuthentication.config[:perms])
  end

  # handle Normal OAuth flow: callback
  def create
    access_token = FacebookAuthentication.get_access_token(params[:code], :redirect_uri => callback_facebook_authentications_url)
    authenticate FacebookAuthentication.add_to_user(current_user, access_token)
    redirect_to root_url
  end
  
  def destroy
    current_user.facebook_authentication.destroy
    
    redirect_to :back
  end
end