module Suitcase
  class Hotel
    extend Suitcase::HotelHelpers

    def initialize(info)
      info.each do |k, v|
        instance_variable_set("@#{k}", v)
      end
    end

    # Public: find hotels by the given information.
    #
    # info - a Hash describing the hotel data
    #        :id - an Integer hotel id provided by Expedia (optional)
    #        :name - a String name of the hotel
    #        :destination - a String location of the hotel
    #        :max_rate - a Float that represents the max price of a room in the hotel
    #        :min_rate - a Float that represents the min price of a room in the hotel
    #        :address - a String that represents the local address
    #        :amenities - an Array of Symbols that represent the requested amenities (max 3)
    #        :max_rating - a Float representing the maximum number of stars
    #        :min_rating - a Float representing the minimum number of stars
    #        :results - an Integer representing the number of desired search results
    #
    # Examples:
    #
    # Hotel.find(:id => 123456)
    # # => #<Hotel @id=123456 @name="..."...>
    #
    # Hotel.find(:destination => "London, UK")
    # # => [#<Hotel @location="London, UK"...>, #<Hotel @location="London, UK"...>...]
    #
    # Returns either a single Hotel or an Array of Hotels.
    def self.find(info)
      if info[:id]
        find_by_id(info[:id])
      else
        find_by_info(info)
      end
    end

    private

    def self.find_by_id(id)
      hotel_info(:hotel_id => id)
    end

    def self.find_by_info(info)
      hotels = []
      puts hotel_list(info)
      hotel_list(info).each do |info|
        parse_hotel_info(info)
        hotels.push(Hotel.new(info))
      end
      hotels
    end
  end
end
