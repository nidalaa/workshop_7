require_relative '../models/user'

module NewsApi
  module Helpers
    def authenticate!
      return if authorized?
      halt 401, {'WWW-Authenticate' => 'Basic realm="Restricted Area"'}, 'Not authorized\n'
    end

    def authorized?
      auth ||=  Rack::Auth::Basic::Request.new(request.env)
      return unless auth.provided? && auth.basic? && auth.credentials

      username, password = auth.credentials
      find_user(username, password)
    end

    def find_user(username, password)
      @user ||= User.find_by(username: username)
      @user = nil unless @user.try(:decrypted_password) == password
      @user
    end

    def respond_with_xml?
      request.accept.first.to_s == 'application/xml'
    end
  end
end
