require 'bcrypt'

class User < ActiveRecord::Base
  include BCrypt

  has_many :stories
  has_many :votes

  validates :username, :presence => true
  validates :password, :presence => true

  def decrypted_password
    @pass ||= Password.new(self.password)
  end

  def decrypted_password=(new_password)
    self.password = Password.create(new_password)
  end
end
