require "spec_helper"

describe RestaurantSerializer do
  let(:restaurant) do
    double(Fabricate.attributes_for(:restaurant, restaurant_id: "12345"))
  end

  let(:serializer) do
    described_class.new(restaurant)
  end

  describe "to_hash" do
    it "returns restaurant hash" do
      expect(serializer.to_hash).to eq ({
        "id"                 => "12345",
        "name"               => "Big Cheese Restaurant",
        "address"            => "123 Cool Street",
        "city"               => "Chicago",
        "state"              => "IL",
        "area"               => "Chicago / Illinois",
        "postal_code"        => "60657",
        "country"            => "United States",
        "phone"              => "(123) 4567890",
        "lat"                => 41.8807,
        "lng"                => -87.6278,
        "reserve_url"        => "http://www.opentable.com/single.aspx?rid=12345",
        "mobile_reserve_url" => "http://mobile.opentable.com/opentable/?restId=12345",
        "image_url"          => "https://www.opentable.com/img/restimages/12345.jpg",
      })
    end
  end
end