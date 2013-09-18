require "faraday"
require "faraday_middleware"

module OpenTable
  class Error < StandardError ; end

  module Request
    API_BASE = "http://opentable.herokuapp.com"

    def connection
      connection = Faraday.new(API_BASE) do |c|
        c.use(Faraday::Request::UrlEncoded)
        c.use(Faraday::Response::ParseJson)
        c.adapter(Faraday.default_adapter)
      end
    end

    def request(method, path, params={}, raw=false)
      headers = {'Accept' => 'application/json'}
      path = "/api#{path}"

      response = connection.send(method, path, params) do |request|
        request.url(path, params)
      end

      if [404, 403, 400].include?(response.status)
        raise OpenTable::Error, response.body["error"]
      end

      raw ? response : response.body
    end

    def get(path, params={})
      request(:get, path, params)
    end
  end

  class Client
    include Request

    def countries
      get("/countries")
    end

    def cities(country=nil)
      get("/cities")
    end

    def restaurants(options={})
      get("/restaurants", options)
    end

    def restaurant(id)
      get("/restaurants/#{id}")
    end
  end
end