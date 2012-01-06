module Suitcase
  class EANException < Exception
    def initialize(message)
      super(message)
    end
  end

  # Used for organizing Bed options
  class BedType
    attr_accessor :id, :description

    def initialize(info)
      @id, @description = info[:id], info[:description]
    end
  end

  # A Class representing a Hotel that stores information
  # about the hotel. It provides methods for checking
  # room availability, fetching images and just general
  # information providing.
  class Hotel
    extend Suitcase::Helpers

    AMENITIES = { pool: 1,
                  fitness_center: 2,
                  restaurant: 3,
                  children_activities: 4,
                  breakfast: 5,
                  meeting_facilities: 6,
                  pets: 7,
                  wheelchair_accessible: 8,
                  kitchen: 9 }

    attr_accessor :id, :name, :address, :city, :province, :min_rate, :max_rate, :amenities, :country_code, :high_rate, :low_rate, :longitude, :latitude, :rating, :postal_code, :supplier_type, :images, :nightly_rate_total, :airport_code, :property_category, :confidence_rating, :amenity_mask, :location_description, :short_description, :hotel_in_destination, :proximity_distance

    # Public: Initialize a new hotel
    #
    # info - a Hash of the options listed in attr_accesor.
    #
    # Returns a new Hotel object with the passed-in attributes.
    def initialize(info)
      info.each do |k, v|
        send (k.to_s + "=").to_sym, v
      end
    end

    # Public: Find a Hotel based on known information
    #
    # info - a Hash of known information
    #
    # Returns a single Hotel if an id is passed in, otherwise
    # an Array of Hotels.
    def self.find(info)
      if info[:id]
        find_by_id(info[:id])
      else
        find_by_info(info)
      end
    end

    # Public: Find a Hotel by it's id.
    #
    # id - an Integer or String representation of the Hotel's
    #      id.
    #
    # Returns a single Hotel object.
    def self.find_by_id(id)
      params = { hotelId: id }
      if Configuration.cache? and Configuration.cache.cached?(:info, params)
        raw = Configuration.cache.get_query(:info, params)
      else
        url = url(:info, params)
        raw = parse_response(url)
        Configuration.cache.save_query(:info, params, raw) if Configuration.cache?
      end
      hotel_data = parse_information(raw)
      Hotel.new(hotel_data)
    end

    # Public: Find a hotel by info other than it's id.
    #
    # info - a Hash of options described in the Hotel
    #        accessors, excluding the id.
    #
    # Returns an Array of Hotels.
    def self.find_by_info(info)
      params = info
      params["numberOfResults"] = params[:results] ? params[:results] : 10
      params.delete(:results)
      params["destinationString"] = params[:location]
      params.delete(:location)
      if params[:amenities]
        params[:amenities].inject("") { |old, new| old + AMENITIES[new].to_s + "," }
        amenities =~ /^(.+),$/
        amenities = $1
      end
      params["minRate"] = params[:min_rate] if params[:min_rate]
      params["maxRate"] = params[:max_rate] if params[:max_rate]
      params[:amenities] = amenities
      hotels = []
      parsed = parse_response(url(:list, params))
      handle_errors(parsed)
      split(parsed).each do |hotel_data|
        hotels.push Hotel.new(parse_information(hotel_data))
      end
      params[:results] ? hotels[0..params[:results]-1] : hotels
    end

    # Public: Parse the information returned by a search request
    #
    # parsed - a Hash representing the parsed JSON
    #
    # Returns a reformatted Hash with the specified accessors.
    def self.parse_information(parsed)
      handle_errors(parsed)
      summary = parsed["hotelId"] ? parsed : parsed["HotelInformationResponse"]["HotelSummary"]
      parsed_info = { id: summary["hotelId"], name: summary["name"], address: summary["address1"], city: summary["city"], postal_code: summary["postalCode"], country_code: summary["countryCode"], rating: summary["hotelRating"], high_rate: summary["highRate"], low_rate: summary["lowRate"], latitude: summary["latitude"].to_f, longitude: summary["longitude"].to_f, province: summary["stateProvinceCode"], airport_code: summary["airportCode"], property_category: summary["propertyCategory"].to_i, proximity_distance: summary["proximityDistance"].to_s + summary["proximityUnit"].to_s }
      parsed_info[:images] = images(parsed) if images(parsed)
      parsed_info
    end

    # Public: Get images from a parsed object
    #
    # parsed - a Hash representing the parsed JSON
    #
    # Returns an Array of Suitcase::Images.
    def self.images(parsed)
      return parsed["HotelInformationResponse"]["HotelImages"]["HotelImage"].map { |image_data| Suitcase::Image.new(image_data) } if parsed["HotelInformationResponse"] && parsed["HotelInformationResponse"]["HotelImages"] && parsed["HotelInformationResponse"]["HotelImages"]["HotelImage"]
      return [Suitcase::Image.new("thumbnailURL" => "http://images.travelnow.com" + parsed["thumbNailUrl"])] unless parsed["thumbnailUrl"].nil? or parsed["thumbNailUrl"].empty?
      return []
    end

    # Handle the errors from the response.
    def self.handle_errors(info)
      if info["HotelRoomAvailabilityResponse"] && info["HotelRoomAvailabilityResponse"]["EanWsError"]
        message = info["HotelRoomAvailabilityResponse"]["EanWsError"]["presentationMessage"]
      elsif info["HotelListResponse"] && info["HotelListResponse"]["EanWsError"]
        message = info["HotelListResponse"]["EanWsError"]["presentationMessage"]
      elsif info["HotelInformationResponse"] && info["HotelInformationResponse"]["EanWsError"]
        message = info["HotelInformationResponse"]["EanWsError"]["presentationMessage"]
      end
      raise EANException.new(message) if message
   end

    def self.split(parsed)
      hotels = parsed["HotelListResponse"]["HotelList"]
      hotels["HotelSummary"]
    end

    def thumbnail_url
      first_image = images.find { |img| img.thumbnail_url != nil }
      first_image.thumbnail_url if first_image
    end

    # Public: Fetch possible rooms from a Hotel.
    #
    # info - a Hash of options described as the accessors in
    #        the Suitcase::Room class
    #
    # Returns an Array of Suitcase::Rooms.
    def rooms(info)
      params = { rooms: [{adults: 1, children_ages: []}] }.merge(info)
      params[:rooms].each_with_index do |room, n|
        params["room#{n+1}"] = room[:adults].to_s + "," + (room[:children_ages].join(",") if room[:children_ages])
      end
      params["arrivalDate"] = info[:arrival]
      params["departureDate"] = info[:departure]
      params["includeDetails"] = true
      params.delete(:arrival)
      params.delete(:departure)
      params["hotelId"] = @id
      parsed = Hotel.parse_response(Hotel.url(:avail, params))
      Hotel.handle_errors(parsed)
      hotel_id = parsed["HotelRoomAvailabilityResponse"]["hotelId"]
      rate_key = parsed["HotelRoomAvailabilityResponse"]["rateKey"]
      supplier_type = parsed["HotelRoomAvailabilityResponse"]["HotelRoomResponse"][0]["supplierType"]
      rooms = parsed["HotelRoomAvailabilityResponse"]["HotelRoomResponse"].map do |raw_data|
        room_data = {}
        room_data[:rate_code] = raw_data["rateCode"]
        room_data[:room_type_code] = raw_data["roomTypeCode"]
        room_data[:room_type_description] = raw_data["roomTypeDescription"]
        room_data[:promo] = raw_data["RateInfo"]["@promo"].to_b
        room_data[:price_breakdown] = raw_data["RateInfo"]["ChargeableRateInfo"]["NightlyRatesPerRoom"]["NightlyRate"].map { |raw| NightlyRate.new(raw) } if raw_data["RateInfo"]["ChargeableRateInfo"] && raw_data["RateInfo"]["ChargeableRateInfo"]["NightlyRatesPerRoom"] && raw_data["RateInfo"]["ChargeableRateInfo"]["NightlyRatesPerRoom"]["NightlyRate"].is_a?(Array)
        room_data[:total_price] = raw_data["RateInfo"]["ChargeableRateInfo"]["@total"]
        room_data[:nightly_rate_total] = raw_data["RateInfo"]["ChargeableRateInfo"]["@nightlyRateTotal"]
        room_data[:average_nightly_rate] = raw_data["RateInfo"]["ChargeableRateInfo"]["@averageRate"]
        room_data[:arrival] = info[:arrival]
        room_data[:departure] = info[:departure]
        room_data[:rate_key] = rate_key
        room_data[:hotel_id] = hotel_id
        room_data[:supplier_type] = supplier_type
        room_data[:rooms] = params[:rooms]
        room_data[:bed_types] = [raw_data["BedTypes"]["BedType"]].flatten.map { |x| BedType.new(id: x["@id"], description: x["description"]) }
        Room.new(room_data)
      end
    end
  end
end
