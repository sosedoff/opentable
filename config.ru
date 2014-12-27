require "bundler/setup"
require "rack/contrib"
require "rack/revision"
require "rack/attack"

require "./app"
require "./lib/rack/geoip"

Rack::Attack.cache.store = RedisStore.new(Redis.current)
Rack::Attack.throttle("reqs", limit: 1000, period: 1.hour) { |req| req.ip }

use Rack::BounceFavicon
use Rack::Revision
use Rack::Runtime
use Rack::JSONP
use Rack::Attack
use Rack::GeoIp, path: "./data/GeoIP.dat"

run Sinatra::Application