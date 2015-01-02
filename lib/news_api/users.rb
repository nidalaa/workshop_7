require_relative '../models/user'

module NewsApi
  class Users < Sinatra::Base
    post '/users' do
      new_user = User.new(JSON.parse(request.body.read))

      if new_user.save
        session[:user_id] = new_user.id
        status 201
      else
        status 422
        { errors: new_user.errors }.to_json
      end
    end

    post "/users/login" do
      login_data = JSON.parse(request.body.read)
      user = User.where(login_data).first

      if user
        session[:user_id] = user.id
        status 201
      else
        status 403
      end
    end

    get "/users/logout" do
      session[:user_id] = nil
    end
  end
end
