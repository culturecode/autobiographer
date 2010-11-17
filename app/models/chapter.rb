class Chapter < ActiveRecord::Base

  include TimelineDetails

  has_one :event, :as => :details

  scope :ascending, {:order => 'timestamp ASC', :joins => :event}
  scope :descending, {:order => 'timestamp DESC', :joins => :event}
  
  validates_presence_of :title
  
  # Returns the next Chapter
  def next
    after.ascending.first
  end

  # Returns the previous chapter
  def previous
    before.ascending.last
  end
  
  # Returns all chapters before this one
  def before
    event.user.chapters.where("timestamp < ?", beginning).joins(:event)
  end
  
  # Returns all chapters after this one
  def after
    event.user.chapters.where("timestamp > ?", beginning).joins(:event)
  end

  # Returns the timestamp of the beginning of this chapter
  def beginning
    event.timestamp
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
  
  # Returns true if this is the first chapter
  def first?
    event.user.chapters.ascending.first == self
  end

  # Returns true if this is the last chapter
  def last?
    event.user.chapters.ascending.last == self
  end
  
  # Returns the chapter number (1 indexed)
  def number
    before.count + 1
  end
  
  # Returns all events in this chapter
  def events
    event.user.events.where(:timestamp => beginning...ending)
  end
end
