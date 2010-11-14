class Event < ActiveRecord::Base
  validates_presence_of :place, :timestamp, :authentication_id, :identifier
  
  scope :ascending, {:order => 'timestamp ASC'}
  scope :descending, {:order => 'timestamp DESC'}
  
end
