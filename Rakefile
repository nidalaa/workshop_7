require 'active_record'
require_relative 'config/environment'

begin
  require "rspec/core/rake_task"

  RSpec::Core::RakeTask.new(:spec)

  task :default => :spec
rescue LoadError
end

namespace :db do
  task :connection do
    Environment.db_connect(ENV['RACK_ENV'])
  end

  task :migrate => :connection do
    ActiveRecord::Migration.verbose = true
    ActiveRecord::Migrator.migrate("db/migrate")
  end

  task :rollback => :connection do
    ActiveRecord::Migrator.rollback("db/migrate")
  end
end

