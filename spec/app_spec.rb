require "spec_helper"

describe "Application" do
  it "it includes api version in header" do
    get "/"

    expect(last_response.headers["X-Api-Version"]).to eq "1.1.0"
  end

  describe "GET /" do
    before do
      get "/"
    end

    it "responds with 200" do
      expect(last_response.status).to eq 200
    end

    it "renders home page" do
      expect(last_response.body).to include "OpenTable API"
    end
  end

  describe "GET /api/stats" do
    before do
      Fabricate(:restaurant)
      get "/api/stats"
    end

    it "responds with 200" do
      expect(last_response.status).to eq 200
    end

    it "returns data stats" do
      expect(json_response).to eq ({
        "countries"   => 1,
        "cities"      => 1,
        "restaurants" => 1
      })
    end
  end

  describe "GET /api/countries" do
    before do
      Fabricate(:restaurant, country: "United States")
      Fabricate(:restaurant, country: "Canada")

      get "/api/countries"
    end

    it "responds with 200" do
      expect(last_response.status).to eq 200
    end

    it "returns unique countries" do
      expect(json_response["count"]).to eq 2
      expect(json_response["countries"]).to eq ["Canada", "United States"]
    end
  end

  describe "GET /api/cities" do
    before do
      Fabricate(:restaurant, city: "Chicago")
      Fabricate(:restaurant, city: "Evanston")

      get "/api/cities"
    end

    it "responds with 200" do
      expect(last_response.status).to eq 200
    end

    it "returns unique cities" do
      expect(json_response["count"]).to eq 2
      expect(json_response["cities"]).to eq ["Chicago", "Evanston"]
    end
  end

  describe "GET /api/restaurants" do
    before do
      Fabricate(:restaurant, city: "Chicago")
      Fabricate(:restaurant, city: "Evanston")

      get "/api/restaurants", params
    end

    context "with no params" do
      let(:params) { Hash.new }

      it "responds with 400" do
        expect(last_response.status).to eq 400
      end

      it "returns error" do
        expect(json_error).to eq "At least one parameter required."
      end
    end

    context "with params" do
      let(:params) { Hash(state: "IL") }

      let(:empty_results) do
        {
          "total_entries" => 0,
          "per_page"      => 25,
          "current_page"  => 1,
          "restaurants"   => []
        }
      end

      it "responds with 200" do
        expect(last_response.status).to eq 200
      end

      it "returns results" do
        expect(json_response["total_entries"]).to eq 2
        expect(json_response["per_page"]).to eq 25
        expect(json_response["current_page"]).to eq 1
        expect(json_response["restaurants"].size).to eq 2
      end

      context "with invalid country value" do
        let(:params) { Hash(country: "FOO") }

        it "responds with 400" do
          expect(last_response.status).to eq 400
        end

        it "returns error" do
          expect(json_error).to eq "Invalid country. Use one of: AE, AW, CA, CH, CN, CR, GP, HK, KN, KY, MC, MO, MX, MY, PT, SA, SG, SV, US, VI"
        end
      end

      context "with invalid pagination value" do
        let(:params) { Hash(state: "IL", per_page: 123) }

        it "responds with 400" do
          expect(last_response.status).to eq 400
        end

        it "returns error" do
          expect(json_error).to eq "Invalid per_page value"
        end
      end

      context "when no restaurants found" do
        let(:params) { Hash(city: "Skokie") }

        it "responds with 200" do
          expect(last_response.status).to eq 200
        end

        it "returns no results" do
          expect(json_response).to eq empty_results
        end
      end
    end
  end

  describe "GET /api/restaurants/:id" do
    let(:restaurant_id) { Fabricate(:restaurant).restaurant_id }

    before do
      get "/api/restaurants/#{restaurant_id}"
    end

    context "when restaurant exists" do
      it "responds with 200" do
        expect(last_response.status).to eq 200
      end

      it "returns restaurant details" do
        expect(json_response).to eq Hash(
          "id"                 => restaurant_id,
          "name"               => "Big Cheese Restaurant",
          "address"            => "123 Cool Street",
          "city"               => "Chicago",
          "state"              => "IL",
          "area"               => "Chicago / Illinois",
          "postal_code"        => "60657",
          "country"            => "United States",
          "phone"              => "(123) 4567890",
          "reserve_url"        => "http://www.opentable.com/single.aspx?rid=#{restaurant_id}",
          "mobile_reserve_url" => "http://mobile.opentable.com/opentable/?restId=#{restaurant_id}"
        )
      end
    end

    context "when restaurant does not exist" do
      let(:restaurant_id) { 12345 }

      it "responds with 404" do
        expect(last_response.status).to eq 404
      end

      it "returns error" do
        expect(json_error).to eq "Restaurant does not exist"
      end
    end
  end

  describe "invalid endpoints" do
    %w(get post put delete).each do |method_name|
      it "returns error on #{method_name.upcase} request" do
        send(method_name.to_sym, "/foobar")

        expect(last_response.status).to eq 404
        expect(json_error).to eq "Invalid endpoint"
      end
    end
  end
end