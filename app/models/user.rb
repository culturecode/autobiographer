class User < ActiveRecord::Base
  has_many :authentication
  has_one  :facebook_authentication
  has_one  :twitter_authentication
  has_many :chapters, :dependent => :destroy
  has_many :events, :through => :authentication, :dependent => :destroy
end
