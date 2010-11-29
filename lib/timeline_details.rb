module TimelineDetails
  def self.included(base)
    base.class_eval do
      attr_accessor :timestamp, :user_id, :insert_before_event, :insert_after_event
      after_create :insert_into_timeline
      has_one :event, :as => :details, :dependent => :destroy
    end
  end

  private

  def insert_into_timeline
    # Try to grab the user_id from the authentication if the object has one
    uid = user_id || (authentication.user_id if uid.blank? && respond_to?(:authentication))
    
    event = Event.new(:details_type => self.class.name, :details_id => self.id, :user_id => uid)
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