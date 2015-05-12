# OpenTable API

This project provides an unofficial json API interface to search OpenTable
restaurant data. It eliminates the need to download, parse and import
data from XLS file. Its an open-source project, hosted on [Github](https://github.com/sosedoff/opentable).

## Overview

- API endpoint: [http://opentable.herokuapp.com/api](http://opentable.herokuapp.com/api)
- Secure API endpoint: [https://opentable.herokuapp.com/api](https://opentable.herokuapp.com/api)
- Response Format: JSON (JSONP is supported too)
- No authentication or API tokens required
- API is throttled with 1000 requests per hour per IP address

## Project Status

- [![Build Status](http://img.shields.io/travis/sosedoff/opentable.svg?style=flat)](https://travis-ci.org/sosedoff/opentable)
- [![Code Climate](http://img.shields.io/codeclimate/github/sosedoff/opentable.svg?style=flat)](https://codeclimate.com/github/sosedoff/opentable)
- [![Coverage Status](https://img.shields.io/coveralls/sosedoff/opentable.svg?style=flat)](https://coveralls.io/r/sosedoff/opentable?branch=master)

## API Reference

### Get data stats

```
GET /api/stats
```

Returns response:

```
{
  "countries": 20,
  "cities": 2700,
  "restaurants": 25000
}
```

### List all cities

```
GET /api/cities
```

Returns response:

```
{
  "count": 1234,
  "cities": [
    "Chicago",
    "San Francisco",
    "New York"
  ]
}
```

### Find restaurants

```
GET /api/restaurants
```

Parameters: (at least one required)

- `price` - Price range for the restaurant. Values: 1-4.
- `name` - Name of the restaurant
- `address` - Address line. Should not contain state or city or zip.
- `state` - State code (ex.: IL)
- `city` - City name (ex.: Chicago)
- `zip` - Zipcode (ex: 60601)
- `country` - Country code (ex: US)
- `page` -  Page (default: 1) 
- `per_page` - Entries per Page, can be one of [5, 10, 15, 25, 50, 100] (default: 25)

Returns response:

```
{
  "count": 521,
  "per_page": 25,
  "current_page": 1,
  "restaurants": [ ... ]
}
```

### Find a single restaurant

```
GET /api/restaurants/:id
```

Returns a single restaurant record, see reference for details. Example:

```json
{
  "id": 107257,
  "name": "Las Tablas Colombian Steak House",
  "address": "2942 N Lincoln Ave",
  "city": "Chicago",
  "state": "IL",
  "area": "Chicago / Illinois",
  "postal_code": "60657",
  "country": "US",
  "phone": "7738712414",
  "lat": 41.935137,
  "lng": -87.662815,
  "price": 2,
  "reserve_url": "http://www.opentable.com/single.aspx?rid=107257",
  "mobile_reserve_url": "http://mobile.opentable.com/opentable/?restId=107257",
  "image_url": "https://www.opentable.com/img/restimages/107257.jpg"
}
```

## Data Reference

Restaurant attributes:

```json
{
  "id": 107257,
  "name": "Las Tablas Colombian Steak House",
  "address": "2942 N Lincoln Ave",
  "city": "Chicago",
  "state": "IL",
  "area": "Chicago / Illinois",
  "postal_code": "60657",
  "country": "US",
  "phone": "7738712414",
  "lat": 41.935137,
  "lng": -87.662815,
  "price": 2,
  "reserve_url": "http://www.opentable.com/single.aspx?rid=107257",
  "mobile_reserve_url": "http://mobile.opentable.com/opentable/?restId=107257",
  "image_url": "https://www.opentable.com/img/restimages/107257.jpg"
}
```

To generate a proper reservation link just ref parameter with your affiliate ID to reserve_url or mobile_reserve_url

## Consuming API

You can use simple client library i wrote — [https://gist.github.com/2504683](https://gist.github.com/2504683)

Example:

```ruby
api = OpenTable::Client.new

# Find restaurants
resp = api.restaurants(:city => "Chicago")

# Process response
resp['count']       # => records found
resp['restaurants'] # => restaurant records

# Fetch a single record
api.restaurant(81169)
```

## Disclaimer

- This service IS NOT affiliated with OpenTable Inc., any of its products or
employees. 
- All content is represented as is and does not have any modifications
to the original data

## Contact

- Dan Sosedoff
- [dan.sosedoff@gmail.com](mailto:dan.sosedoff@gmail.com)
- [http://twitter.com/sosedoff](http://twitter.com/sosedoff)
- [https://github.com/sosedoff/opentable](https://github.com/sosedoff/opentable)

Please **DO NOT** contact author about services and products not related to this project.

## License

This software is distributed under MIT license
