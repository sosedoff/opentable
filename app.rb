require "./boot"
require "sinatra"
require "sinatra/reloader" if development?

VERSION = "1.2.0"

configure do
  set :protection, false
end

configure :production do
  require "skylight/sinatra"
  Skylight.start!
end

helpers do
  def error_response(message, code=400)
    result = {
      error: message, 
      status: code
    }

    content_type(:json, encoding: "utf8")
    halt(code, result.to_json)
  end

  def success_response(data)
    content_type(:json, encoding: "utf8")
    data.to_json
  end
end

before do
  headers["X-Api-Version"] = VERSION
  headers["Access-Control-Allow-Origin"] = "*"
end

after do
  if request.env["geo"]
    code = request.env["geo"][:country_code2]
    Redis.current.hincrby("req_count", code, 1)
  end
end

get "/" do
  erb :index
end

get "/metrics" do
  success_response(Redis.current.hgetall("req_count"))
end

get "/api" do
  success_response(
    endpoints: {
      "/api/stats"           => "Get various stats on available data",
      "/api/countries"       => "Get list of all available countries",
      "/api/cities"          => "Get list of all available cities",
      "/api/restaurants"     => "Search restaurants",
      "/api/restaurants/:id" => "Get a single restaurant details"
    }
  )
end

get "/api/stats" do
  success_response(
    countries:   Restaurant.unique_countries.size,
    cities:      Restaurant.unique_cities.size,
    restaurants: Restaurant.count
  )
end

get "/api/countries" do
  results = Restaurant.unique_countries.sort
  success_response(count: results.size, countries: results)
end

get "/api/cities" do
  results = Restaurant.unique_cities
  success_response(count: results.size, cities: results)
end

get "/api/restaurants" do
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

get "/api/restaurants/:id" do
  record = Restaurant.by_id(params[:id])

  if record.nil?
    error_response("Restaurant does not exist", 404)
  end

  success_response(record)
end

get "/*" do
  error_response("Invalid endpoint", 404)
end

post "/*" do
  error_response("Invalid endpoint", 404)
end

put "/*" do
  error_response("Invalid endpoint", 404)
end

delete "/*" do
  error_response("Invalid endpoint", 404)
end