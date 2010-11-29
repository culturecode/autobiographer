class Photo < ActiveRecord::Base
  belongs_to :photo_group
  
  mount_uploader :file, FileUploader
end