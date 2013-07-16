class RestaurantPresenter
  attr_reader :record, :options

  def initialize(record, options={})
    @record  = record
    @options = options
  end

  def to_hash
    {
      'id'                 => record.restaurant_id,
      'name'               => record.name,
      'address'            => record.address,
      'city'               => record.city,
      'state'              => record.state,
      'area'               => record.metro_name,
      'postal_code'        => record.postal_code,
      'country'            => record.country,
      'phone'              => record.phone,
      'reserve_url'        => "http://www.opentable.com/single.aspx?rid=#{record.restaurant_id}",
      'mobile_reserve_url' => "http://mobile.opentable.com/opentable/?restId=#{record.restaurant_id}",
    }
  end
end