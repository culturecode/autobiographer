class FoursquareAuthentication < Authentication  
  def sync_events
    response = access_token.get("http://api.foursquare.com/v1/history.json")
    history = JSON.parse(response.body)
    
    history["checkins"].each do |checkin|
      Event.find_or_create_by_identifier(:identifier => checkin["id"], 
                                         :authentication_id => self.id,
                                         :place => checkin["venue"]["name"], 
                                         :comment => checkin["shout"], 
                                         :timestamp => checkin["created"])
    end
  end
  
  def access_token
    @access_token ||= OAuth::AccessToken.new(self.class.consumer, self.token, self.secret)
  end
  
  def self.request_token(callback_url)
    consumer.get_request_token(:oauth_callback => callback_url)
  end
  
  def self.get_access_token(verifier_token, request_token, request_secret)
    request_token = OAuth::RequestToken.new(consumer, request_token, request_secret)
    request_token.get_access_token(:oauth_verifier => verifier_token)
  end
  
  def self.identifier(access_token)
    user_info = access_token.get("http://api.foursquare.com/v1/user.json")
    JSON.parse(user_info.body)["user"]["id"]
  end
  
  def self.token(access_token)
    access_token.token
  end
  
  def self.secret(access_token)
    access_token.secret
  end
  
  private
  
  def self.consumer
    OAuth::Consumer.new(config[:client_token], config[:client_secret], {
      :site               => "http://foursquare.com",
      :scheme             => :header,
      :http_method        => :post,
      :request_token_path => "/oauth/request_token",
      :access_token_path  => "/oauth/access_token",
      :authorize_path     => "/oauth/authorize"
      })
  end
  
  def self.config
    @config ||= if ENV['fs_client_token'] && ENV['fs_client_secret']
      {
        :client_token  => ENV['fs_client_token'],
        :client_secret => ENV['fs_client_secret']
      }
    else
      YAML.load_file("#{Rails.root}/config/foursquare.yml")[Rails.env].symbolize_keys
    end
  rescue Errno::ENOENT => e
    raise StandardError.new("config/foursquare.yml could not be loaded.")
  end
end
