class User < ActiveRecord::Base
  has_many :authentications
  has_one  :autobiographer_authentication
  has_one  :facebook_authentication
  has_one  :twitter_authentication
  has_one  :foursquare_authentication

  has_many :chapters, :through => :events, :source => :chapter, :conditions => "events.details_type = 'Chapter'", :dependent => :destroy
  has_many :photo_groups, :through => :events, :source => :photo_group, :conditions => "events.details_type = 'PhotoGroup'", :dependent => :destroy

  has_many :events, :dependent => :destroy
  
  after_create :create_initial_chapter, :create_autobiographer_authentication
  
  def sync_events
    authentications.each(&:sync_events)
  end
  
  private
  
  def create_initial_chapter
    Chapter.create!(:title => "My life to date", :user => self, :timestamp => DateTime.parse('January 1, 0001'))
  end
  
  def create_autobiographer_authentication
    AutobiographerAuthentication.create!(:identifier => self.id, :user => self)
  end
end
