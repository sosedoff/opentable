begin
  require "rspec/core/rake_task"
rescue LoadError
  puts "Rspec is not loaded"
end

if defined?(RSpec)
  RSpec::Core::RakeTask.new(:test) do |t|
    t.pattern = "spec/**/*_spec.rb"
    t.verbose = false
  end
end

task :default => :test

task :environment do
  require "./boot"
end

namespace :opentable do
  desc "Flush all OpenTable data"
  task :flush => :environment do 
    Restaurant.delete_all
  end

  desc "Import and update a fresh OpenTable data"
  task :import => :environment do
    parser  = OpenTable::Parser.new(ENV["CSV_FILE"])
    Restaurant.delete_all
    records = Restaurant.import_records(parser.parse)
  end
end

task :console => :environment do
  require "irb"
  require "irb/completion"
  require "pp"
  
  ARGV.clear
  IRB.start
end

namespace :redis do
  task :flush => :environment do
    Redis.current.flushall
  end
end