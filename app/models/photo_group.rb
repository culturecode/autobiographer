class PhotoGroup < ActiveRecord::Base
  include TimelineDetails
  
  has_many :photos, :after_remove => :photo_removed_callback, :dependent => :destroy
  has_one :note, :as => :notable, :dependent => :destroy
    
  private
  
  def photo_removed_callback(photo)
    # Destroy the photogroup if it is now empty, or touch the photogroup to update the timestamp so caching works properly
    photos.empty? ? destroy : touch
  end  
end
