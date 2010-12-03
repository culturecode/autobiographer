class FoursquareAuthenticationsController < ApplicationController
  skip_before_filter :require_authentication
  
  # handle Normal OAuth flow: start
  def new
    request_token = FoursquareAuthentication.request_token(callback_foursquare_authentications_url)
    
    session[:foursquare_request_token]  = request_token.token
    session[:foursquare_request_secret] = request_token.secret
    
    redirect_to request_token.authorize_url
  end

  # handle Normal OAuth flow: callback
  def create
    access_token = FoursquareAuthentication.get_access_token(params[:oauth_verifier], session[:foursquare_request_token], session[:foursquare_request_secret])
    authenticate FoursquareAuthentication.add_to_user(current_user, access_token)
    
    redirect_to root_url
  end
  
  def destroy
    current_user.foursquare_authentication.destroy
    
    redirect_to :back
  end
end