$LOAD_PATH << File.dirname(__FILE__)

require 'bundler/setup'
require 'yaml'
require 'mongoid'
require 'mongoid-pagination'

require 'lib/restaurant_presenter'
require 'lib/open_restaurant'

root_dir = File.dirname(__FILE__)

Mongoid.logger = false
Mongoid.load!(File.join(root_dir, 'config', 'mongoid.yml'))