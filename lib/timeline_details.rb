module TimelineDetails
  def self.included(base)
    base.class_eval do
      attr_accessor :timestamp, :user_id, :insert_before_event, :insert_after_event
      after_create :insert_into_timeline
      after_destroy :remove_from_timeline
    end
  end

  private

  def insert_into_timeline
    event = Event.new(:details_type => self.class.name, :details_id => self.id, :user_id => user_id)
    if insert_before_event
      event.insert_before(Event.find(insert_before_event))
    elsif insert_after_event
      event.insert_after(Event.find(insert_after_event))
    else
      event.timestamp = timestamp
      event.save!
    end
  end

  def remove_from_timeline
    self.event.destroy
  end
end