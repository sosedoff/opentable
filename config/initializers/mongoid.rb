Mongoid.logger = ENV["RACK_ENV"] == "development"
Mongoid.load!("config/mongoid.yml")
