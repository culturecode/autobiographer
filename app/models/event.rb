class Event < ActiveRecord::Base
  belongs_to :authentication
  belongs_to :user
  
  belongs_to :details, :polymorphic => true, :dependent => :destroy  
  belongs_to :chapter, :class_name => "Chapter", :foreign_key => "details_id"
  belongs_to :photo_group, :class_name => "PhotoGroup", :foreign_key => "details_id"
      
  validates_presence_of :timestamp, :user_id, :details_id, :details_type
  
  default_scope where(:hidden => false)
  scope :ascending, {:order => 'events.timestamp ASC, events.offset ASC'}
  scope :descending, {:order => 'events.timestamp DESC, events.offset DESC'}
    
  def self.increment_offsets(events)
    return if events.empty?
    update_all('"offset" = "offset" + 1', :id => events)
  end

  def self.decrement_offsets(events)
    return if events.empty?
    update_all('"offset" = "offset" - 1', :id => events)
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
  
  # Returns true if this event happened on the same day as +other_event+
  def happened_same_day_as(other_event)
    self.timestamp.localtime.to_date == other_event.timestamp.localtime.to_date
  end
  
  # Returns true if the event occurred between midnight and noon
  def morning?
    0 <= self.timestamp.localtime.hour && self.timestamp.localtime.hour < 12
  end
  
  # Returns true if the event occurred between noon and 5pm
  def afternoon?
    12 <= self.timestamp.localtime.hour && self.timestamp.localtime.hour < 17
  end

  # Returns true if the event occurred between 6pm and midnight
  def evening?
    17 <= self.timestamp.localtime.hour && self.timestamp.localtime.hour < 24
  end
    
  # Returns the next event
  def next
    after.ascending.first
  end

  # Returns the previous event
  def previous
    before.ascending.last
  end
  
  # Returns all events before this one
  def before
    user.events.where('timestamp < ? OR (timestamp = ? AND "offset" < ?)', self.timestamp, self.timestamp, offset)
  end
  
  # Returns all events after this one
  def after
    user.events.where('timestamp > ? OR (timestamp = ? AND "offset" > ?)', self.timestamp, self.timestamp, offset)
  end
  
  # Returns the event number (1 indexed)
  def number
    before.count + 1
  end  
end
