class User < ActiveRecord::Base
  has_many :authentications
  has_one  :facebook_authentication
  has_one  :twitter_authentication
  has_one  :foursquare_authentication
  has_many :chapters, :dependent => :destroy
  has_many :events, :through => :authentications, :dependent => :destroy
  
  after_create :create_initial_chapter
  
  def sync_events
    authentications.each(&:sync_events)
  end
  
  private
  
  def create_initial_chapter
    chapters.create(:title => "WTF Happened Last Night", :timestamp => DateTime.new)
  end
end
