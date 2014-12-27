require "geoip"

module Rack
  class GeoIp
    def initialize(app, options = {})
      @app   = app
      @geoip = GeoIP.new(options[:path])
    end

    def call(env)
      req = Rack::Request.new(env)

      if req.path_info =~ /^api/
        env["geo"] = geolocate(req.ip)
      end

      @app.call(env)
    end

    private

    def geolocate(ip)
      result = @geoip.country(ip)
      result.country_code == 0 ? nil : result.to_hash
    rescue StandardError => err
      STDERR.puts "GeoIp Error: #{err.inspect}"
      nil
    end
  end
end