# Unofficial OpenTable API

This project provides an unofficial json API interface to search OpenTable
restaurant data. It eliminates the need to download, parse and import
data from XLS file. 

Its an open-source project, view [source on github](https://github.com/sosedoff/opentable).

## Usage

- API endpoint: [http://opentable.herokuapp.com/api](http://opentable.herokuapp.com/api)
- Secure API endpoint: [https://opentable.herokuapp.com/api](https://opentable.herokuapp.com/api)
- Response Format: JSON (JSONP is supported too)
- No authentication or API tokens required
- API is throttled with 1000 requests per hour per IP address

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

- `name` - Name of the restaurant *optional*
- `address` - Address line. Should not contain state or city or zip. *optional*
- `state` - State code (ex.: IL) *optional*
- `city` - City name (ex.: Chicago) *optional*
- `zip` - Zipcode (ex: 60601) *optional*
- `country` - Country code (ex: US) *optional*

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

Returns a single restaurant record, see reference for details.

## Reference

Restaurant attributes:

```
{
  "id": 55807,
  "name": "ALC Steaks (Austin Land & Cattle)",
  "address": "1205 N. Lamar Blvd",
  "city": "Austin",
  "state": "TX",
  "area": "Austin",
  "postal_code": "78703",
  "country": "US",
  "phone": "5124721813",
  "reserve_url": "http://www.opentable.com/single.aspx?rid=55807",
  "mobile_reserve_url": "http://mobile.opentable.com/opentable/?restId=55807"
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

- This service is not affiliated with OpenTable Inc., any of its products or
employees. 
- All content is represented as is and does not have any modifications
to the original data
- Restaurant data has extra columns to simplify integration with OpenTable website

## Contact

- Dan Sosedoff
- [dan.sosedoff@gmail.com](mailto:dan.sosedoff@gmail.com)
- [http://twitter.com/dan_sosedoff](http://twitter.com/dan_sosedoff)
- [https://github.com/sosedoff/opentable](https://github.com/sosedoff/opentable)