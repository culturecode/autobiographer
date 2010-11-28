class User < ActiveRecord::Base
  has_many :authentications
  has_one  :facebook_authentication
  has_one  :twitter_authentication
  has_one  :foursquare_authentication

  has_many :notes, :through => :events, :source => :note, :conditions => "events.details_type = 'Note'"
  has_many :chapters, :through => :events, :source => :chapter, :conditions => "events.details_type = 'Chapter'"
  has_many :events, :dependent => :destroy
  has_many :photos, :dependent => :destroy
  
  after_create :create_initial_chapter
  
  def sync_events
    authentications.each(&:sync_events)
  end
  
  private
  
  def create_initial_chapter
    Chapter.create!(:title => "My life to date", :user_id => self.id, :timestamp => DateTime.parse('January 1, 0001'))
  end
end
