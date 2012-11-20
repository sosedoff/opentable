# OpenRestaurant record contains all fields from original snapshot plus
# extra fields for latitude and longitude that are not geocoded by default.
# This is a pretty expensive operation due to amount of records, so should be
# done using background processing with delay when using free services like
# Google Geocode (geocoder) which has hard limits on amounts of geocoding requests.

class OpenRestaurant
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Pagination

  field :restaurant_id, :type => Integer
  field :name
  field :address
  field :city
  field :state
  field :postal_code
  field :metro_name
  field :phone
  field :country
  field :latitude,  :type => Float
  field :longitude, :type => Float
  field :location,  :type => Array

  validates :restaurant_id, :presence => true, :uniqueness => true
  validates :name,          :presence => true

  index :restaurant_id
  index :city
  index :state
  index :postal_code

  def as_json(options={})
    RestaurantPresenter.new(self, options).to_hash
  end

  def self.by_id(id)
    OpenRestaurant.where(:restaurant_id => id).first
  end

  def self.import_records(results)
    results.map do |item|
      r = OpenRestaurant.by_id(item['restaurant_id']) || OpenRestaurant.new
      r.attributes = item
      r.save
    end
  end
end