require 'rubygems'
require 'bundler'
require 'rack'

Bundler.require
require './app.rb'

run Sinatra::Application