require 'net/http'
require 'uri'
require 'json'
require 'api_key'

module Suitcase
  class Hotel
    attr_accessor :id, :address, :city, :postal_code, :country, :airport_code, :rating, :confidence_rating, :description, :high_rate, :low_rate, :currency, :latitude, :longitude 

    def self.near(location, number_of_results)
      unparsed = Net::HTTP.get_response(URI.parse("http://api.ean.com/ean-services/rs/hotel/v3/list?apiKey=#{API_KEY}&city=#{location}&numberOfResults=#{number_of_results}")).body
      json = JSON.parse unparsed
      json["HotelListResponse"]["HotelList"]["HotelSummary"].each do |hotel_data|
        h = Hotel.new
        h.id = hotel_data["hotelId"]
        h.name = hotel_data["name"]
      end
    end

    def geolocation
      latitude + ", " + longitude
    end

    def complete_address
      address + " " + city + ", " + country + " " + postal_code
    end
  end
end

include Suitcase
Hotel.near("London", 10)
