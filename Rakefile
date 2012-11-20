# Mongoid needs some env set if not running with rails or sinatra
ENV['RACK_ENV'] ||= 'development'

require './boot'

namespace :opentable do
  desc 'Show OpenTable data stats'
  task :stats do
    num = OpenRestaurant.count
    num_cities = OpenRestaurant.collection.distinct('city').count

    puts "Restaurants: #{num}"
    puts "Cities: #{num_cities}"
  end

  desc 'Flush all OpenTable data'
  task :flush do 
    OpenRestaurant.delete_all
  end

  desc 'Download data snapshot'
  task :download do
    require 'lib/open_table/downloader'

    config = YAML.load_file('./config/opentable.yml')

    downloader = OpenTable::Downloader.new(config)
    downloader.download_to('/tmp/opentable.xls', true)
  end

  desc 'Import and update a fresh OpenTable data'
  task :import do
    require 'lib/open_table/parser'

    parser = OpenTable::Parser.new('/tmp/opentable.xls')
    results = parser.parse { |row| row['country'] == 'US' }
    records = OpenRestaurant.import_records(results)
  end
end