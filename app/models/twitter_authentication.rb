class TwitterAuthentication < Authentication
  def sync_subclass_events
    options = {}
    options[:since_id] = most_recent_event.identifier if most_recent_event.present?
            
    Twitter.user_timeline(self.identifier, options).each do |tweet|
      Comment.create!(:text => tweet.text, :identifier => tweet.id, :authentication_id => self.id, :timestamp => tweet.created_at)
    end
  end
  
  def self.identifier(access_token)
    access_token  
  end
end
