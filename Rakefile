require 'rspec/core/rake_task'
require 'active_record'
require 'dotenv'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

namespace :db do
  task :connection do
    env_file_path = "../.env"
    env_file_path = "../.env.test" if ['test', 'development'].include? ENV['RACK_ENV']
    Dotenv.load(File.expand_path(env_file_path,  __FILE__))

    ActiveRecord::Base.establish_connection(
      :adapter => 'sqlite3',
      :database =>  ENV['DATABASE_URL']
    )
  end

  task :migrate => :connection do
    ActiveRecord::Migration.verbose = true
    ActiveRecord::Migrator.migrate("db/migrate")
  end

  task :rollback => :connection do
    ActiveRecord::Migrator.rollback("db/migrate")
  end
end

