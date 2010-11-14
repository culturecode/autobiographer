class FacebookAuthentication < Authentication  
  def sync_events
    facebook_user.checkins.each do |checkin|
      Event.find_or_create_by_identifier(:identifier => checkin.identifier, 
                                         :authentication_id => self.id,
                                         :place => checkin.place.name, 
                                         :comment => checkin.message, 
                                         :timestamp => checkin.created_time)
    end
    
    facebook_user.statuses.each do |status|
      Event.find_or_create_by_identifier(:identifier => status.identifier, 
                                         :authentication_id => self.id, 
                                         :comment => status.message, 
                                         :timestamp => status.updated_time)
    end
  end
  
  def self.authorize_url(*args)
    auth.client.web_server.authorize_url(*args)
  end
  
  def self.get_access_token(*args)
    auth.client.web_server.get_access_token(*args)
  end
  
  def self.identifier(access_token)
    FbGraph::User.me(access_token).fetch.identifier
  end
  
  def self.token(access_token)
    access_token.token
  end
  
  private
  
  def facebook_user
    @facebook_user ||= FbGraph::User.me(self.token).fetch
  end
  
  def self.auth
    FbGraph::Auth.new config[:client_id], config[:client_secret]
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
