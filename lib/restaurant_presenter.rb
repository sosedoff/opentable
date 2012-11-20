class RestaurantPresenter
  attr_reader :restaurant, :options

  def initialize(restaurant, options={})
    unless restaurant.kind_of?(OpenRestaurant)
      raise ArgumentError, "OpenRestaurant instance required"
    end

    @restaurant = restaurant
    @options    = options
  end

  def to_hash
    {
      'id'            => restaurant.restaurant_id,
      'name'          => restaurant.name,
      'address'       => restaurant.address,
      'city'          => restaurant.city,
      'state'         => restaurant.state,
      'area'          => restaurant.metro_name,
      'postal_code'   => restaurant.postal_code,
      'country'       => restaurant.country,
      'latitude'      => restaurant.latitude,
      'longitude'     => restaurant.longitude,
      'location'      => [restaurant.latitude, restaurant.longitude],
      'phone'         => restaurant.phone,
      'reserve_url'        => "http://www.opentable.com/single.aspx?rid=#{restaurant.restaurant_id}",
      'mobile_reserve_url' => "http://mobile.opentable.com/opentable/?restId=#{restaurant.restaurant_id}",
    }
  end
end