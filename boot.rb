ENV["RACK_ENV"] ||= "development"

$LOAD_PATH << File.dirname(__FILE__)
require "bundler/setup"

# Load vars from .env filr
require "dotenv"
Dotenv.load

# Basic gems
require "yaml"
require "mongoid"
require "mongoid-pagination"
require "redis"

# App files
require "app/models/restaurant"
require "app/serializers/restaurant_serializer"
require "lib/open_table"
require "lib/search"
require "lib/redis_store"
require "config/initializers/redis"
require "config/initializers/mongoid"