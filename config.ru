require 'bundler/setup'
require 'rack/contrib'
require 'rack/revision'
require 'rack/attack'
require './app'

Rack::Attack.cache.store = RedisStore.new($redis)
Rack::Attack.throttle("reqs", limit: 1000, period: 1.hour) { |req| req.ip }

use Rack::BounceFavicon
use Rack::Revision
use Rack::Runtime
use Rack::JSONP
use Rack::Attack

run Sinatra::Application