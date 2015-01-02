require_relative '../models/user'

module NewsApi
  module Helpers
    def protected!
      return if authorized?
      headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
      halt 401, "Not authorized\n"
    end

    def users_only!
      return if logged_in?
      headers['Location'] = '/users/login'
      halt 403, "Loggin-in is neccessary\n"
    end

    def authorized?
      auth ||=  Rack::Auth::Basic::Request.new(request.env)
      auth.provided? and auth.basic? and auth.credentials and auth.credentials == ['admin', 'secret']
    end

    def logged_in?
      return false unless session['user_id']

      user ||= User.find(session['user_id'])
      user
    end
  end
end
