class UploadsController < ApplicationController
  def photos
    current_user.photos << Photo.new(:file => params[:file])
  end
end