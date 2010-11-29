class PhotoGroup < ActiveRecord::Base
  include TimelineDetails
  
  belongs_to :authentication
  has_many :photos
end
