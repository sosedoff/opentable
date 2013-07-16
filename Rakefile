task :environment do
  require './boot'
end

namespace :opentable do
  desc 'Flush all OpenTable data'
  task :flush => :environment do 
    Restaurant.delete_all
  end

  desc 'Download data snapshot'
  task :download => :environment do
    config     = YAML.load_file('./config/opentable.yml')
    downloader = OpenTable::Downloader.new(config)

    downloader.download_to('/tmp/opentable.xls', true)
  end

  desc 'Import and update a fresh OpenTable data'
  task :import => :environment do
    countries = %w(US CA MX)

    parser  = OpenTable::Parser.new('/tmp/opentable.xls')
    results = parser.parse { |row| countries.include?(row['country']) }
    records = Restaurant.import_records(results)
  end
end