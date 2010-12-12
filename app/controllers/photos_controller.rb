class PhotosController < ApplicationController
  def create
    photo = Photo.new(:file => params[:file])
    photo_timestamp = EXIFR::JPEG.new(photo.file.path).date_time_original
    
    photo_group = Event.where(:details_type => "PhotoGroup", :authentication_id => current_user.autobiographer_authentication.id, :timestamp => (photo_timestamp - 1.hour)..(photo_timestamp + 1.hour)).first.try(:details)
    photo_group ||= PhotoGroup.create(:authentication => current_user.autobiographer_authentication, :timestamp => photo_timestamp)
    
    photo_group.photos << photo
    
    render :nothing => true
  end
  
  def destroy
    photo = Photo.find(params[:id])

    if photo_group = current_user.photo_groups.find(photo.photo_group.id)
      photo_group.photos.destroy(params[:id])
    end

    respond_to do |format|
      format.html { redirect_to :back }
      format.js { render :nothing => true }
    end
  end
end