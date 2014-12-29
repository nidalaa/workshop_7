require 'sinatra/base'
require 'dotenv'
require 'active_record'
require 'json'

require_relative 'news_api/stories'
require_relative 'news_api/votes'
require_relative 'news_api/users'

module NewsApi
  class App < Sinatra::Base
    env_file_path = "../../.env"
    env_file_path = "../../.env.test" if [:test, :development].include? settings.environment

    Dotenv.load(File.expand_path(env_file_path,  __FILE__))

    ActiveRecord::Base.establish_connection(
      :adapter => 'sqlite3',
      :database =>  ENV['DATABASE_URL']
    )

    use NewsApi::Stories
    use NewsApi::Votes
    use NewsApi::Users

    run! if app_file == $0
  end
end



