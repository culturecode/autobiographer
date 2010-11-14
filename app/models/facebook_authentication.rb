class FacebookAuthentication < Authentication
  def profile
    @profile ||= FbGraph::User.me(self.credentials).fetch
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

  def self.auth
    FbGraph::Auth.new config[:client_id], config[:client_secret]
  end
end
