class TwitterAuthenticationsController < ApplicationController
  skip_before_filter :require_authentication
  
  def new
    @twitter_authentication = TwitterAuthentication.new
  end

  def create
    authenticate TwitterAuthentication.add_to_user(current_user, params[:twitter_authentication][:token])
    redirect_to root_url
  end
end