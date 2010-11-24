class Note < ActiveRecord::Base
  include TimelineDetails
  
  has_one :event, :as => :details    
end
