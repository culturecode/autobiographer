class Discussion < ActiveRecord::Base
  include TimelineDetails
  
  serialize :messages, Array
  
  has_one :note, :as => :notable, :dependent => :destroy  
  
  validates_presence_of :identifier
end
