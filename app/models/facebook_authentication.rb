class FacebookAuthentication < Authentication  
  def sync_events
    facebook_user.checkins.each do |checkin|
      Event.find_or_create_by_identifier(:identifier => checkin.id, 
                                         :authentication_id => self.id,
                                         :place => checkin.place.name, 
                                         :comment => checkin.message, 
                                         :timestamp => checkin.created_time)
    end
    
    facebook_user.statuses.each do |status|
      Event.find_or_create_by_identifier(:identifier => status.id, 
                                         :authentication_id => self.id, 
                                         :comment => status.message, 
                                         :timestamp => status.updated_time)
    end
  end
  
  def self.auth
    FbGraph::Auth.new config[:client_id], config[:client_secret]
  end
  
  private
  
  def facebook_user
    @facebook_user ||= FbGraph::User.me(self.credentials).fetch
  end
  
  def self.config
    @config ||= if ENV['fb_app_id'] && ENV['fb_client_id'] && ENV['fb_client_secret'] && ENV['fb_perms']
      {
        :app_id        => ENV['fb_app_id'],
        :client_id     => ENV['fb_client_id'],
        :client_secret => ENV['fb_client_secret'],
        :perms         => ENV['fb_perms']
      }
    else
      YAML.load_file("#{Rails.root}/config/facebook.yml")[Rails.env].symbolize_keys
    end
  rescue Errno::ENOENT => e
    raise StandardError.new("config/facebook.yml could not be loaded.")
  end
end
