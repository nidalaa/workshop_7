require 'bcrypt'

class User < ActiveRecord::Base
  include BCrypt

  has_many :stories
  has_many :votes

  validates :username, :presence => true
  validates :encrypted_password, :presence => true

  def password
    @password ||= Password.new(self.encrypted_password)
  end

  def password=(new_password)
    self.encrypted_password = Password.create(new_password)
  end
end
