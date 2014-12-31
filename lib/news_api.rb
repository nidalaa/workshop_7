require 'sinatra/base'
require 'active_record'
require 'json'

require_relative '../config/environment'
require_relative 'news_api/stories'
require_relative 'news_api/votes'
require_relative 'news_api/users'

module NewsApi
  class App < Sinatra::Base
    ::Environment.db_connect(settings.environment)

    use NewsApi::Stories
    use NewsApi::Votes
    use NewsApi::Users

    run! if app_file == $0
  end
end



