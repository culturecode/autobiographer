class Comment < ActiveRecord::Base
  include TimelineDetails
  
  belongs_to :authentication

  validates_presence_of :identifier, :authentication_id
end
