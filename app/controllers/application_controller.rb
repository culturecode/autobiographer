class ApplicationController < ActionController::Base
  protect_from_forgery
  
  include AuthenticatedSystem
  
  before_filter :require_authentication
end
