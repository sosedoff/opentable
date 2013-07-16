require './boot'
require 'sinatra'
require 'sinatra/reloader' if development?

VERSION = '1.0.0'

configure do
  set :protection, false
end

helpers do
  def error_response(message, code=400)
    result = {
      error: message, 
      status: code
    }

    content_type(:json, encoding: 'utf8')
    halt(code, result.to_json)
  end

  def success_response(data)
    content_type(:json, encoding: 'utf8')
    data.to_json
  end

  def build_regex(val)
    Regexp.new(Regexp.escape(val), Regexp::IGNORECASE)
  end
end

before do
  headers['X-Api-Version'] = VERSION
end

not_found do
  error_response("Invalid endpoint", 404)
end

get '/' do 
  erb :index
end

get '/api/countries' do
  results = Restaurant.collection.distinct('country').sort
  success_response(:count => results.size, :countries => results)
end

get '/api/cities' do
  results = Restaurant.collection.distinct('city').sort
  success_response(:count => results.size, :cities => results)
end

get '/api/restaurants' do
  if params.empty? 
    error_response("At least one parameter required.")
  end

  filters = {}

  if params[:name]
    str = params[:name].to_s.strip
    if str.empty?
      error_response("Name should not be empty.")
    end
    filters[:name] = build_regex(str)
  end

  if params[:address]
    str = params[:address].to_s.strip
    filters[:address] = build_regex(str)
  end

  if params[:state]
    filters[:state] = params[:state].to_s.upcase
  end

  if params[:city]
    filters[:city] = build_regex(params[:city].to_s.strip)
  end

  country = params[:country].to_s.upcase

  unless country.empty?
    if Restaurant.valid_country?(country)
      filters[:country] = country
    else
      error_response("Invalid country. Use one of #{Restaurant::COUNTRIES.join(', ')}")
    end
  end

  if params[:country]
    filters[:country] = params[:country].to_s.strip
  end

  if params[:zip]
    filters[:postal_code] = params[:zip].to_s.strip
  end

  page = params[:page] || 1
  per_page = 25

  results = Restaurant.
    where(filters).
    paginate(:page => page, :per_page => per_page)

  success_response(
    :count        => results.size, 
    :per_page     => per_page,
    :current_page => page,
    :restaurants  => results
  )
end

get '/api/restaurants/:id' do
  record = Restaurant.by_id(params[:id])
  if record.nil?
    error_response("Restaurant was not found.", 404)
  end
  success_response(record)
end