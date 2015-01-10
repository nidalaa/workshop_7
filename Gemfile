source 'https://rubygems.org'

gem 'sinatra'
gem 'activerecord', '~> 4.2.0'
gem 'dotenv', '~> 1.0.2'
gem 'bcrypt-ruby', '~> 3.1.5'

group :production do
  gem 'pg'
end

group :development, :test do
   gem 'sqlite3'
end

group :test do
  gem 'sqlite3'
  gem 'rspec'
  gem 'rake', '~> 10.4.2'
  gem 'rack-test', '~> 0.6.2'
  gem 'database_cleaner', '~> 1.3.0'
end
