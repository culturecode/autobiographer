class UploadsController < ApplicationController
  def photos
    photo = Photo.new(:file => params[:file])
    photo_timestamp = EXIFR::JPEG.new(photo.file.path).date_time
    
    photo_group = Event.where(:details_type => "PhotoGroup", :user_id => current_user.id, :timestamp => (photo_timestamp - 1.hour)..(photo_timestamp + 1.hour)).first.try(:details)
    photo_group ||= PhotoGroup.create(:authentication => current_user.autobiographer_authentication, :timestamp => photo_timestamp)
    
    photo_group.photos << photo
    
    render :nothing => true
  end
end