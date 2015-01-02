$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'news_api'
require 'models/story'
require 'models/user'
require 'rack/test'
require 'database_cleaner'

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
