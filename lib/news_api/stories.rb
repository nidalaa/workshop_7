require_relative '../models/story'
require_relative 'helpers'

module NewsApi
  class Stories < Sinatra::Base
    include NewsApi::Helpers

    get '/stories' do
      Story.all.to_json
    end

    get '/stories/:id' do
      if story = Story.find_by(id: params['id'])
        story.to_json
      else
        halt 404
      end
    end

    post '/stories' do
      protected!

      new_story = Story.create(JSON.parse(request.body.read).merge(user_id: @user.id))
      if new_story.save
        status 201
        headers \
          "Location" => "/stories/#{new_story.id}"
      else
        status 422
        { errors: new_story.errors }.to_json
      end
    end
  end
end

