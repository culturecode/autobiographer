class TwitterAuthentication < Authentication
  def sync_events    
    twitter_user_timeline.each do |tweet|
      Event.find_or_create_by_identifier(:identifier => tweet.id, 
                                         :authentication_id => self.id, 
                                         :comment => tweet.text, 
                                         :timestamp => tweet.created_at)
    end
  end
  
  def self.identifier(access_token)
    access_token  
  end
  
  private
  
  def twitter_user_timeline
    @twitter_user ||= Twitter.user_timeline(self.identifier)
  end
end
