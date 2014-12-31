require 'active_record'
require 'dotenv'

class Environment
  def self.db_connect(env)
    env_file_path =  [:test, :development].include?(env) ? ".env.test" : ".env"
    Dotenv.load(env_file_path)

    ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])
  end
end
