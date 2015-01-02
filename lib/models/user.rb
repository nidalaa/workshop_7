class User < ActiveRecord::Base
  has_many :stories

  validates :username, :presence => true
  validates :password, :presence => true
end
