class User < ActiveRecord::Base
  has_many :authentication
  has_one :facebook_authentication
  has_one :twitter_authentication
end
