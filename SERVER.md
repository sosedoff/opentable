# Installation Instructions

Steps to get API server up and running with OpenTable data

## Install

Fetch code via git:

```
git clone git@github.com:sosedoff/opentable.git
```

Install all dependencies:

```
cd opentable
bundle install
```

## Configure

### Mongoid

You'll need MongoDB 2.x running locally. Create a new `config/mongoid.yml` file with contents:

```
defaults: &defaults
  host: localhost
  use_utc: true
  use_activesupport_time_zone: true
  identity_map_enabled: true
  max_retries_on_connection_failure: 5
  raise_not_found_error: false

development:
  <<: *defaults
  database: opentable_development

test:
  <<: *defaults
  database: opentable_test

production:
  <<: *defaults
  host: YOUR_HOST
  port: 27737
  database: opentable_production
  username: YOUR_USERNAME
  password: YOUR_PASSWORD
  logger: false
```

### Opentable

Edit `config/opentable.yml` file with your credentials that you get from OpenTable representative:

```
:host: "HOST"
:user: "USER"
:password: "PASSWORD"
```

## Import data

There are few rake tasks to operate with data:

```
rake opentable:download  # Download data snapshot
rake opentable:flush     # Flush all OpenTable data
rake opentable:import    # Import and update a fresh OpenTable data
rake opentable:stats     # Show OpenTable data stats
```

You'll need to download OpenTable data snapshot first:

```
rake opentable:download
```

And import data:

```
rake opentable:flush
rake opentable:import
```
