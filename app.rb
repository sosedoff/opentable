require './boot'
require 'sinatra'
require 'sinatra/reloader' if development?

configure do
  set :protection, false
end

helpers do
  def error_response(message, code=400)
    content_type(:json, :encoding => :utf8)
    halt(code, {:error => message, :code => code}.to_json)
  end

  def success_response(data)
    content_type(:json, :encoding => :utf8)
    data.to_json
  end

  def build_regex(val)
    Regexp.new(Regexp.escape(val), Regexp::IGNORECASE)
  end

  def render_markdown(body, highlight=true)
    data = body.gsub(/^``` ?([^\r\n]+)?\r?\n(.+?)\r?\n```\r?$/m) do
      lang = $1 || 'no-highlight'
      if highlight && !$1.to_s.empty?
        str = "<pre class='#{lang}'>#{$2}</pre>"
      else
        str = "<pre class='#{lang}'>#{$2}</pre>"
      end
      str
    end

    Docify.render(data, 'markdown')
  end
end

not_found do
  error_response("Invalid route", 404)
end

get '/' do 
  @readme = File.read('./README.md')
  erb :index
end

get '/api/countries' do
  results = OpenRestaurant.collection.distinct('country').sort
  success_response(:count => results.size, :countries => results)
end

get '/api/cities' do
  results = OpenRestaurant.collection.distinct('city').sort
  success_response(:count  => results.size, :cities => results)
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

  if params[:country]
    filters[:country] = params[:country].to_s.strip
  end

  if params[:zip]
    filters[:postal_code] = params[:zip].to_s.strip
  end

  page = params[:page] || 1
  per_page = 25

  results = OpenRestaurant.
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
  record = OpenRestaurant.by_id(params[:id])
  if record.nil?
    error_response("Restaurant was not found.", 404)
  end
  success_response(record)
end