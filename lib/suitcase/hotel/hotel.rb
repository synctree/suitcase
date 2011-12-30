module Suitcase
  class EANException < Exception
    def initialize(message)
      super(message)
    end
  end

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

    attr_accessor :id, :name, :address, :city, :min_rate, :max_rate, :amenities, :country_code, :high_rate, :low_rate, :longitude, :latitude, :rating, :postal_code, :supplier_type, :images

    def initialize(info)
      info.each do |k, v|
        send (k.to_s + "=").to_sym, v
      end
    end

    def self.find(info)
      if info[:id]
        find_by_id(info[:id])
      else
        find_by_info(info)
      end
    end

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
      hotels
    end

    def self.parse_information(parsed)
      handle_errors(parsed)
      summary = parsed["hotelId"] ? parsed : parsed["HotelInformationResponse"]["HotelSummary"]
      parsed_info = { id: summary["hotelId"], name: summary["name"], address: summary["address1"], city: summary["city"], postal_code: summary["postalCode"], country_code: summary["countryCode"], rating: summary["hotelRating"], high_rate: summary["highRate"], low_rate: summary["lowRate"], latitude: summary["latitude"].to_f, longitude: summary["longitude"].to_f }
      parsed_info[:images] = images(parsed) if images(parsed)
      parsed_info
    end

    def self.images(parsed)
      return parsed["HotelInformationResponse"]["HotelImages"]["HotelImage"].map { |image_data| Suitcase::Image.new(image_data) } if parsed["HotelInformationResponse"]
      return Suitcase::Image.new(url: parsed["thumbNailUrl"]) if parsed["thumbNailUrl"]
    end

    # Bleghh. so ugly. #needsfixing
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

    def rooms(info)
      params = { rooms: [{children: 0, ages: []}] }.merge(info)
      params[:rooms].each_with_index do |room, n|
        params["room#{n+1}"] = (room[:children] == 0 ? "" : room[:children].to_s + ",").to_s + room[:ages].join(",").to_s
      end
      params["arrivalDate"] = info[:arrival]
      params["departureDate"] = info[:departure]
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
        room_data[:price_breakdown] = raw_data["RateInfo"]["ChargeableRateInfo"]["NightlyRatesPerRoom"]["NightlyRate"].map { |raw| NightlyRate.new(raw) }
        room_data[:total_price] = raw_data["RateInfo"]["ChargeableRateInfo"]["@total"]
        room_data[:nightly_rate_total] = raw_data["RateInfo"]["ChargeableRateInfo"]["@nightlyRateTotal"]
        room_data[:average_nightly_rate] = raw_data["RateInfo"]["ChargeableRateInfo"]["@averageRate"]
        Room.new(room_data)
      end
      RoomGroup.new(rate_key, hotel_id, supplier_type, rooms)
    end
  end
end
