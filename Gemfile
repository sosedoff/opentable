source "https://rubygems.org"
ruby "2.1.5"

gem "sinatra",            "~> 1.4"
gem "sinatra-contrib",    "~> 1.4"
gem "mongo",              "~> 1.9"
gem "bson",               "~> 1.9"
gem "bson_ext",           "~> 1.9"
gem "mongoid",            "~> 2.4"
gem "mongoid-pagination", "~> 0.2"
gem "redcarpet",          "~> 2.1"
gem "thin",               "~> 1.5"
gem "roo",                "~> 1.0"
gem "rake",               "~> 10"
gem "redis",              "~> 3.0"
gem "rack-contrib",       "~> 1.1"
gem "rack-revision",      "~> 1.0"
gem "rack-attack",        "~> 2.2"
gem "dotenv",             "~> 0.9"
gem "geoip",              "~> 1.4"

group :development, :test do
  gem "rspec",            "~> 2.13"
  gem "rack-test",        "~> 0.6"
  gem "database_cleaner", "~> 1.2"
  gem "simplecov",        "~> 0.8"
  gem "fabrication",      "~> 2.9"
  gem "coveralls",        "~> 0.7"
end

group :production do
  gem "skylight", "0.3.20", require: false
end