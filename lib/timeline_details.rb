module TimelineDetails
  def self.included(base)
    base.class_eval do
      attr_accessor :timestamp, :user_id
      after_create :insert_into_timeline
      after_destroy :remove_from_timeline
    end
  end

  private

  def insert_into_timeline
    Event.create!(:timestamp => timestamp, :details_type => self.class.name, :details_id => self.id, :user_id => user_id)
  end
  def remove_from_timeline
    self.event.destroy
  end
end