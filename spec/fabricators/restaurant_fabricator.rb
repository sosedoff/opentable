Fabricator(:restaurant) do
  restaurant_id do
    sequence(:restaurant_id) { |i| "OT#{i}" }
  end

  name "Big Cheese Restaurant"
  address "123 Cool Street"
  city "Chicago"
  state "IL"
  metro_name "Chicago / Illinois"
  postal_code "60657"
  country "United States"
  phone "(123) 4567890"
end