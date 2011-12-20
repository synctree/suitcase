require 'net/http'
require 'uri'
require 'json'
require File.dirname(__FILE__) + '/../country_codes'

module Suitcase
  class Hotel
    attr_accessor :id, :name, :address, :city, :postal_code, :country, :airport_code, :rating, :confidence_rating, :description, :high_rate, :low_rate, :tripadvisor_rating, :currency_code, :latitude, :longitude, :geo_accuracy

    GEO_ACCURACY = { 0 => :unknown,
                     1 => :exact,
                     2 => :street,
                     3 => :zip,
                     4 => :city,
                     5 => :province,
                     6 => :country }

    BASE_URL = "http://api.ean.com/ean-services/rs/hotel/v3/"

    # Public: Create a new hotel object.
    #
    # hash - A Hash of options that describes the hotel.
    #        :id - The unique ID from Expedia
    #        :name - The name of the hotel
    #        :address - The address of the hotel
    #        :city - The city of the hotel
    #        :postal_code - The postal code of the hotel
    #        :country - The country of the hotel
    #        :airport_code - The code of the nearest airport to the hotel
    #        :rating - The rating of the hotel
    #        :confidence_rating - The confidence rating of the hotel
    #        :tripadvisor_rating - The TripAdvisor rating of the hotel
    #        :currency_code - The currency code used in the country of the hotel
    #        :latitude - The latitude portion of the coordinates of the hotel
    #        :longitude - The longitude portion of the coordinates of the hotel
    #        :high_rate - The highest price of a room in the hotel
    #        :low_rate - The lowest price of a room in the hotel
    #        :geo_acccuracy - A Symbol describing the known geographical accuracy
    #
    # Examples
    #
    # Hotel.new(id: 5, name: "Monte Carlo Hotel", address: "6 Some Road, Middle, Nowhere", city: "Middle", country: "Nowhere", airport_code: "LHR", rating: 4, confidence_rating: 3.5, tripadvisor_rating: 4.1, currency_code: "USD", latitude: -15.3412, longitude: 16.245, high_rate: "154.31", low_rate: "96.23", geo_accuracy: :exact)
    # => #<Hotel id=5...>
    #
    # Returns a Hotel object.
    def initialize(hash)
      hash.each do |k, v|
        instance_variable_set("@#{k}", v) unless v.nil? 
      end
    end

    # Private: Create a url based on the base hotel API url and passed params.
    #
    # action - A String action name.
    # params - A Hash of paramters for the request
    #
    # Examples
    #
    # url("list", location: "London, UK", cid; 5505)
    # => "http://url/list?location=London,%20UK&cid=5505"
    #
    # Returns a URL to the corresponding API call.
    def self.url(action, params)
      url = BASE_URL + action + "?"
      params.each do |k, v|
        url += k.to_s + "=" + v.to_s + "&"
      end
      URI.escape(url)
    end

    # Public: Find a hotel(s) that matches the query.
    #
    # hash - A Hash of options that describes the query:
    #        :near - The location to use as a reference location when searching for the hotels
    #        :results - The number of results
    #
    # Examples
    #
    # Hotel.find(:near => "Boston, MA", :results => 4)
    # # => [#<Hotel @id=1, @name="...", @address="...", @city="...">,...]
    #
    # Returns an Array of Hotels.
    def self.find(hash)
      defaults = { :results => 10 }
      hash = defaults.merge(hash)
      hotels = []
      link = url("list", apiKey: Suitcase::Hotel::API_KEY, city: hash[:near], numberOfResults: hash[:results])
      uri = URI.parse(URI.escape(link))
      json = JSON.parse Net::HTTP.get_response(uri).body
      if json["HotelListResponse"]["HotelList"]
        json["HotelListResponse"]["HotelList"]["HotelSummary"].each do |hotel_data|
          h = Hotel.new(id: hotel_data["hotelId"], name: hotel_data["name"], address: hotel_data["address1"], city: hotel_data["city"], postal_code: hotel_data["postalCode"], airport_code: hotel_data["airportCode"], rating: hotel_data["hotelRating"], confidence_rating: hotel_data["confidenceRating"], currency_code: hotel_data["rateCurrencyCode"], latitude: hotel_data["latitude"], longitude: hotel_data["longitude"], high_rate: hotel_data["highRate"], low_rate: hotel_data["lowRate"], geo_accuracy: GEO_ACCURACY[hotel_data["geoAccuracy"]])
          hotels.push(h)
        end
        hotels[0..hash[:results]-1]
      else
        if json["HotelListResponse"]["EanWsError"]
          raise "The following error occured while accessing #{URI.parse(URI.escape("http://api.ean.com/ean-services/rs/hotel/v3/info?apiKey=#{Suitcase::Hotel::API_KEY}&city=#{hash[:near]}&numberOfResults=#{hash[:results]}"))}: #{json["HotelListResponse"]["EanWsError"]}"
        end
      end
    end

    # Public: Find a hotel by it's ID.
    #
    # Examples
    #
    # Hotel.find_by_id(249134)
    # => #<Hotel id=249134, ..>
    #
    # Returns a hotel object.
    def self.find_by_id(id)
      json = JSON.parse(url "info", "apiKey" => Suitcase::Hotel::API_KEY, "hotelId" => id)["HotelInformationResponse"]
      if !json["HotelInformationResponse"]["EanWsError"]
        Hotel.new(id: id, name: json["HotelSummary"]["name"], address: json["HotelSummary"]["address1"], city: json["HotelSummary"]["city"], postal_code: json["HotelSummary"]["postalCode"], airport_code: json["HotelSummary"]["airportCode"], rating: json["HotelSummary"][""])
      else
        raise "The following error occurred while accessing #{URI.parse(URI.escape("http://api.ean.com/ean-services/rs/hotel/v3/info?apiKey=#{Suitcase::Hotel::API_KEY}&hotelId=#{id}"))}: #{json["HotelInformationResponse"]["EanWsError"]}"
      end
    end

    # Public: Reserve the hotel with the user's information.
    #
    # Examples
    #
    # @hotel.reserve(info)
    # => true
    #
    # @hotel.reserve(invalid_info)
    # => ["Invalid payment information"]
    #
    # Returns either true or an array of errors, depending on success.
    def reserve!(hash)

    end

    # Public: List available rooms given checkin and checkout dates.
    #
    # Examples
    #
    # @hotel.rooms(:checkin => "April 27, 2012", :checkout => "May 3, 2012")
    # => [#<Hotel::Room ..>, .. #<Hotel::Room ..>]
    #
    # Returns an array of room objects.
    def rooms(hash)
      checkin = Date.parse(hash[:checkin]).month + "/" + Date.parse(hash[:checkin]).day + "/" + Date.parse(hash[:checkin]).year
      checkout = Date.parse(hash[:checkout]).month + "/" + Date.parse(hash[:checkout]).day + "/" + Date.parse(hash[:checkout]).year
      json = JSON.parse Net::HTTP.get_response(URI.parse(URI.escape("http://api.ean.com/ean-services/rs/hotel/v3/list?apiKey=#{Suitcase::Hotel::API_KEY}&hotelId=#{id}=#{hash[:near]}&arrivalDate=#{checkin}&departureDate=#{checkout}&numberOfResults=#{hash[:results]}"))).body
      puts json
    end

    # Public: Access the geolocation (latitude and longitude) of the hotel.
    #
    # Examples
    #
    # @hotel.geolocation
    # # => "-36.003143, 42.12343"
    #
    # Returns a String of the form longitude, latitude.
    def geolocation
      latitude + ", " + longitude
    end

    # Public: Access the address of the hotel.
    #
    # Examples
    # @hotel.address
    # => "10 Avery Street, Boston, USA, 02111
    #
    # Return a string of the address.
    def complete_address
      address + " " + city + ", " + country + " " + postal_code
    end
  end
end
