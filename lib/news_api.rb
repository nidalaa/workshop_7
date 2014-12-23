require 'sinatra'
require 'json'

class NewsApi
  def initialize
    @data = { stories:
                [ { id: "1", title: "Lorem ipsum", url: "http://www.lipsum.com/" },
                { id: "2", title: "Lorem", url: "http://www.lorem.com/" } ]
            }
  end

  def all_stories
    @data
  end

  def find_story(id)
    @data[:stories].select { |story| story[:id] == id }.first
  end
end


news_api = NewsApi.new

get '/stories' do
  news_api.all_stories.to_json
end

get '/stories/:id' do
  if story = news_api.find_story(params['id'])
    story.to_json
  else
    halt 404
  end
end
