require_relative '../models/story_storage'

module NewsApi
  class Stories < Sinatra::Base
    get '/stories' do
      StoryStorage.all_stories.to_json
    end

    get '/stories/:id' do
      if story = StoryStorage.find_story(params['id'])
        story.to_json
      else
        halt 404
      end
    end
  end
end

