require_relative '../models/story'

module NewsApi
  class Stories < Sinatra::Base
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
  end
end

