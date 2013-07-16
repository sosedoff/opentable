class Restaurant
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Pagination

  self.collection_name = 'open_restaurants'

  field :restaurant_id, type: Integer
  field :name
  field :address
  field :city
  field :state
  field :postal_code
  field :metro_name
  field :phone
  field :country
  field :latitude,  type: Float
  field :longitude, type: Float
  field :location,  type: Array

  validates :restaurant_id, presence: true, uniqueness: true
  validates :name,          presence: true

  index :restaurant_id
  index :city
  index :state
  index :postal_code

  def as_json(options={})
    RestaurantPresenter.new(self, options).to_hash
  end

  def self.by_id(id)
    Restaurant.where(restaurant_id: id).first
  end

  def self.import_records(results)
    results.map do |item|
      r = Restaurant.by_id(item['restaurant_id']) || Restaurant.new
      r.attributes = item
      r.save
      r
    end
  end
end