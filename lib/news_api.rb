require 'sinatra/base'
require 'json'

require_relative 'news_api/stories'
require_relative 'news_api/votes'
require_relative 'news_api/users'

module NewsApi
  class App < Sinatra::Base
    use NewsApi::Stories
    use NewsApi::Votes
    use NewsApi::Users

    run! if app_file == $0
  end
end



