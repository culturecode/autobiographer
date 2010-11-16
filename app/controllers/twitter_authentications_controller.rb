class TwitterAuthenticationsController < ApplicationController
  skip_before_filter :require_authentication
  
  # handle Normal OAuth flow: start
  def new
    request_token = TwitterAuthentication.request_token(callback_twitter_authentications_url)
    
    session[:twitter_request_token]  = request_token.token
    session[:twitter_request_secret] = request_token.secret
    
    redirect_to request_token.authorize_url
  end

  # handle Normal OAuth flow: callback
  def create
    access_token = TwitterAuthentication.get_access_token(params[:oauth_verifier], session[:twitter_request_token], session[:twitter_request_secret])
    authenticate TwitterAuthentication.add_to_user(current_user, access_token)
    
    redirect_to root_url
  end
end