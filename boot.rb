ENV['RACK_ENV'] ||= 'development'

$LOAD_PATH << File.dirname(__FILE__)

require 'bundler/setup'
require 'yaml'
require 'mongoid'
require 'mongoid-pagination'
require 'redis'

require 'app/models/restaurant'
require 'app/presenters/restaurant_presenter'
require 'lib/open_table'
require 'lib/search'

root_dir = File.dirname(__FILE__)

# Initialize MongoDB
Mongoid.logger = false
Mongoid.load!(File.join(root_dir, 'config', 'mongoid.yml'))

# Initialize Redis
redis_url = ENV["REDIS_URL"] || ENV["REDISCLOUD_URL"] || "redis://localhost:6379"
uri = URI.parse(redis_url)
$redis = Redis.new(host: uri.host, port: uri.port, password: uri.password)