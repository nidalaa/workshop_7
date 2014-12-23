require 'sinatra/base'
require 'json'

require_relative 'news_api/stories'
require_relative 'news_api/votes'
require_relative 'news_api/users'

class NewsApi < Sinatra::Base
  run! if app_file == $0
end



