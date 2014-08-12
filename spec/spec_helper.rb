ENV["RACK_ENV"] = "test"

require "simplecov"

if ENV["CI"]
  require "coveralls"
  Coveralls.wear!
end

SimpleCov.start do
  add_filter ".bundle"
end

require "sinatra"
require "rack/test"
require "fabrication"
require "database_cleaner"

require File.join(File.dirname(__FILE__), "..", "app.rb")

Fabrication.configure do |config|
  config.fabricator_path = "spec/fabricators"
  config.path_prefix     = File.dirname(__FILE__)
  config.sequence_start  = 10000
end

require "spec/fabricators/restaurant_fabricator"

module ApiHelpers
  def json_response
    MultiJson.load(last_response.body)
  end

  def json_error
    json_response["error"]
  end
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include ApiHelpers

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.clean
    Redis.current.flushall
  end

  config.after(:each) do
    Redis.current.flushall
  end
end

configure do
  set :environment, :test
  set :run, false
  set :raise_errors, true
  set :logging, false
  set :views, "views"
end

def fixture_path
  File.expand_path("../fixtures", __FILE__)
end

def fixture(file)
  File.read(File.join(fixture_path, file))
end

def app
  Sinatra::Application
end