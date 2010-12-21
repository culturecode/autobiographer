class FacebookAuthentication < Authentication  
  def sync_subclass_events
    options = {}
    options[:since] = most_recent_event.timestamp if most_recent_event.present?
    
    facebook_user.checkins(options).each do |checkin|
      ActiveRecord::Base.transaction do
        Checkin.create!(:place => checkin.place.name, :comment => checkin.message, :identifier => checkin.identifier, :authentication => self, :timestamp => checkin.created_time)
      end
    end
    
    facebook_user.statuses(options).each do |status|
      ActiveRecord::Base.transaction do
        Comment.create!(:text => status.message, :identifier => status.identifier, :authentication => self, :timestamp => status.updated_time)
      end
    end
    
    facebook_user.events(options).each do |event|
      ActiveRecord::Base.transaction do
        Activity.create!(:name => event.name, :place => event.place, :start_time => event.start_time, :end_time => event.end_time, :rsvp_status => event.rsvp_status, :identifier => event.identifier, :authentication => self, :timestamp => event.start_time)
      end
    end
    
    facebook_user.inbox(options).each do |thread|
      ActiveRecord::Base.transaction do
        messages = [{:message => thread.message, :from => thread.from.name}]
        messages.concat thread.messages.collect{|message| {:message => message.message, :from => message.from.name}}
        Discussion.create!(:subject => thread.subject, :messages => messages, :identifier => thread.identifier, :authentication => self, :timestamp => thread.updated_time)
      end
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
