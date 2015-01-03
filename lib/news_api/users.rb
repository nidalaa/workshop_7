require_relative '../models/user'

module NewsApi
  class Users < Sinatra::Base
    post '/users' do
      new_user = User.new(JSON.parse(request.body.read))

      if new_user.save
        status 201
      else
        status 422
        { errors: new_user.errors }.to_json
      end
    end

  end
end
