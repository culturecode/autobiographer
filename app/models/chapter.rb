class Chapter < ActiveRecord::Base

  belongs_to :user

  scope :ascending, {:order => 'timestamp ASC'}
  scope :descending, {:order => 'timestamp DESC'}
  
  validates_presence_of :user_id, :title, :timestamp

  # Returns the next Chapter
  def next
    user.chapters.where("timestamp > ?", self.beginning).first
  end

  def previous
    user.chapters.where("timestamp < ?", self.beginning).first
  end

  def beginning
    self.timestamp
  end

  # Returns the timestamp of the end of the chapter
  def ending
    # If there's a next chapter, return that timestamp
    # Else, if there's an event, but it's before the end of this chapter, return the timestamp of this chapter
    # Else return the timestamp of the user's last event
    if self.next
      self.next.beginning
    else
      Time.now + 1.hour
    end
  end
  
  # Returns all events in this chapter
  def events
    user.events.where(:timestamp => beginning..ending)
  end
end
