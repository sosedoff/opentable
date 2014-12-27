require "geoip"

module Rack
  class GeoIp
    def initialize(app, options = {})
      @app   = app
      @geoip = GeoIP.new(options[:path])
    end

    def call(env)
      env["geo"] = geolocate(env)
      @app.call(env)
    end

    private

    def geolocate(env)
      ip = Rack::Request.new(env).ip
      ip = "216.70.68.173"
      result = @geoip.country(ip)

      if result.country_code == 0
        return nil
      end

      result.to_hash

    rescue StandardError => err
      STDERR.puts "GeoIp Error: #{err.inspect}"
      nil
    end
  end
end