# Unofficial OpenTable API

This project was created for one purpose — to make OpenTable data easily
accesible to developers. No longer do you have to download XLS file, parse it
and insert into your app's database.

Created by Dan Sosedoff during #railsconf 2012 in Austin, TX

## Usage

- API Endpoint: http://opentable.heroku.com/api
- Response Format: JSON

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

You can use simple client library i wrote — https://gist.github.com/2504683

Example:

```
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

This service is not affiliated with OpenTable Inc., any of its products or
employees. All content is represented as is and does not have any modifications
to the original data except additional fields listed under reference section.

For additional information you can contact developer via [email](mailto:
dan.sosedoff@gmail.com)
