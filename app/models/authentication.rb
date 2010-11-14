class Authentication < ActiveRecord::Base
  belongs_to :user
  
  def self.identify(identifier, token)
    authentication = find_or_initialize_by_identifier(identifier)
    authentication.credentials = token
    authentication.user ||= User.create
    authentication.save!
    
    return authentication.user
  end
end
