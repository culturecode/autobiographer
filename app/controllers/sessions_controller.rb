class SessionsController < ApplicationController
  skip_before_filter :require_authentication
  
  def destroy
    unauthenticate
    redirect_to root_url
  end
end