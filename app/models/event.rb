class Event < ActiveRecord::Base
  belongs_to :details, :polymorphic => true
  belongs_to :user
  
  validates_presence_of :timestamp, :user_id, :details_id, :details_type
  
  scope :ascending, {:order => 'timestamp ASC'}
  scope :descending, {:order => 'timestamp DESC'}
end
