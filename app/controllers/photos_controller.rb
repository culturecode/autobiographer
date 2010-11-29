class PhotosController < ApplicationController
  def destroy
    photo = Photo.find(params[:id])

    if photo_group = current_user.photo_groups.find(photo.photo_group.id)
      photo_group.photos.destroy(params[:id])
    end

    respond_to do |format|
      format.html{redirect_to :back}
      format.js{ render 'events/index.js.erb' }
    end
  end
end