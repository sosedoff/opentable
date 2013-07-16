require 'bundler/setup'
require 'rack/contrib'
require 'rack/revision'
require './app'

use Rack::BounceFavicon
use Rack::Revision
use Rack::Runtime
use Rack::JSONP

run Sinatra::Application