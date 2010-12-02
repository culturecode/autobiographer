class Comment < ActiveRecord::Base
  include TimelineDetails

  validates_presence_of :identifier
end
