class Event < ActiveRecord::Base
  belongs_to :authentication
  belongs_to :user
  
  belongs_to :details, :polymorphic => true  
  belongs_to :note, :class_name => "Note", :foreign_key => "details_id"
  belongs_to :chapter, :class_name => "Chapter", :foreign_key => "details_id"
  belongs_to :photo_group, :class_name => "PhotoGroup", :foreign_key => "details_id"
  
  validates_presence_of :timestamp, :user_id, :details_id, :details_type
  
  scope :ascending, {:order => 'events.timestamp ASC, events.offset ASC'}
  scope :descending, {:order => 'events.timestamp DESC, events.offset DESC'}
  
  def self.increment_offsets(events)
    return if events.empty?
    update_all("offset = offset + 1", :id => events)
  end

  def self.decrement_offsets(events)
    return if events.empty?
    update_all("offset = offset - 1", :id => events)
  end
  
  # Inserts the current event before the given event
  def insert_before(event)
    self.timestamp = event.timestamp
    self.offset = event.offset - 1
    
    transaction do
      Event.decrement_offsets(event.earlier_offset_events)
      save!
    end
  end
  
  # Inserts the current event after the given event
  def insert_after(event)
    self.timestamp = event.timestamp
    self.offset = event.offset + 1
    
    transaction do
      Event.increment_offsets(event.later_offset_events)
      save!
    end
  end
    
  # Returns all events at this timestamp with an earlier offset
  def earlier_offset_events
    Event.where(["events.timestamp = ? AND events.offset < ?", self.timestamp, self.offset])
  end
  
  # Returns all events at this timestamp with a later offset
  def later_offset_events
    Event.where(["events.timestamp = ? AND events.offset > ?", self.timestamp, self.offset])
  end
end
