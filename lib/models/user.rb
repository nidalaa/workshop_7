class User < ActiveRecord::Base
  has_many :stories
  has_many :votes

  validates :username, :presence => true
  validates :password, :presence => true
end
