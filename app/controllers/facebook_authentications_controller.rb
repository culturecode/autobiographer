class FacebookAuthenticationsController < ApplicationController
  skip_before_filter :require_authentication
  
  # handle Normal OAuth flow: start
  def new
    redirect_to FacebookAuthentication.auth.client.web_server.authorize_url(
      :redirect_uri => callback_facebook_authentications_url,
      :scope => FacebookAuthentication.config[:perms]
    )
  end

  # handle Normal OAuth flow: callback
  def create
    access_token = FacebookAuthentication.auth.client.web_server.get_access_token(
      params[:code],
      :redirect_uri => callback_facebook_authentications_url
    )
    user = FbGraph::User.me(access_token).fetch
    authenticate FacebookAuthentication.identify(user.identifier, user.access_token.token)
    redirect_to root_url
  end
end