class Photo < ActiveRecord::Base
  belongs_to :photo_group, :touch => true
  
  mount_uploader :file, FileUploader
end