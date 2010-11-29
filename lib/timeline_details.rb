module TimelineDetails
  def self.included(base)
    base.class_eval do
      attr_accessor :timestamp, :insert_before_event, :insert_after_event, :authentication, :user
      after_create :insert_into_timeline
      has_one :event, :as => :details, :dependent => :destroy
    end
  end

  private

  def insert_into_timeline
    # Try to grab the user_id from the authentication if the object has one
    event = Event.new(:details_type => self.class.name, :details_id => self.id, :authentication => authentication, :user => user || authentication.user)
    
    if insert_before_event
      event.insert_before(Event.find(insert_before_event))
    elsif insert_after_event
      event.insert_after(Event.find(insert_after_event))
    else
      event.timestamp = timestamp
      event.save!
    end
  end
end