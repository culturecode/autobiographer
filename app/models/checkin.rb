class Checkin < ActiveRecord::Base
  include TimelineDetails

  has_one :note, :as => :notable, :dependent => :destroy
  
  validates_presence_of :identifier
  
end
