require './boot'
require 'sinatra'
require 'sinatra/reloader' if development?

VERSION = '1.0.1'

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
end

before do
  headers['X-Api-Version'] = VERSION
end

get "/" do
  erb :index
end

get "/api/countries" do
  results = Restaurant.unique_countries
  success_response(count: results.size, countries: results)
end

get '/api/cities' do
  results = Restaurant.unique_cities
  success_response(count: results.size, cities: results)
end

get '/api/restaurants' do
  if params.empty? 
    error_response("At least one parameter required.")
  end

  begin
    search = Search.new(params)
    results = search.results
    
    success_response(
      total_entries: results.size,
      per_page:      search.per_page,
      current_page:  search.page,
      restaurants:   results
    )
  rescue SearchError => err
    error_response(err.message)
  end
end

get '/api/restaurants/:id' do
  record = Restaurant.by_id(params[:id])

  if record.nil?
    error_response("Restaurant does not exist", 404)
  end

  success_response(record)
end

get "/*" do
  error_response("Invalid endpoint", 404)
end