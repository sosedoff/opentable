Mongo::Logger.logger.level = ::Logger::FATAL
Mongoid.load!("config/mongoid.yml", ENV["RACK_ENV"].to_sym)
