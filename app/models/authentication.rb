class Authentication < ActiveRecord::Base
  belongs_to :user
  has_many :events
  
  validates_presence_of :identifier, :user_id
  
  def self.add_to_user(user, token_object)
    authentication = find_or_initialize_by_identifier identifier(token_object)
    authentication.token = token(token_object)
    authentication.secret = secret(token_object)
    authentication.user ||= user || User.create
    authentication.save!
    
    return authentication.user
  end
  
  def self.identifier(token_object)
    raise NotImplementedError
  end
  
  def self.token(token_object)
    nil
  end
  
  def self.secret(token_object)
    nil
  end
  
  def sync_events
    raise NotImplementedError
  end
end
