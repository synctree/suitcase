module Suitcase
  class EANException < Exception
    def initialize
      super("TravelNow.com cannot service this request")
    end
  end

  class Hotel
    AMENITIES = { pool: 1,
                  fitness_center: 2,
                  restaurant: 3,
                  children_activities: 4,
                  breakfast: 5,
                  meeting_facilities: 6,
                  pets: 7,
                  wheelchair_accessible: 8,
                  kitchen: 9 }
    EXCEPTIONS = { -1 => EANException
                  }

    attr_accessor :id, :name, :address, :city, :min_rate, :max_rate, :amenities, :country_code, :high_rate, :low_rate, :longitude, :latitude, :rating, :postal_code, :supplier_type, :image_urls

    def initialize(info)
      info.each do |k, v|
        send (k.to_s + "=").to_sym, v
      end
    end

    def self.url(action, include_key, include_cid, params)
      url = "http://api.ean.com/ean-services/rs/hotel/v3/" + action.to_s + "?"
      include_key ? params["apiKey"] = Suitcase::Hotel::API_KEY : nil
      include_cid ? params["cid"] = "55505" : nil
      params.each do |k, v|
        url += k.to_s + "=" + v.to_s + "&"
      end
      if url =~ /^(.+)&$/
        url = $1
      end
      URI.parse URI.escape(url)
    end

    def self.find(info)
      if info[:id]
        find_by_id(info[:id])
      else
        find_by_info(info)
      end
    end

    def self.find_by_id(id)
      Hotel.new(parse_hotel_information(hit(url(:info, true, true, { hotelId: id }))))
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
      raw = hit(url(:list, true, true, params))
      handle_errors(JSON.parse raw)
      split(raw).each do |hotel_data|
        hotels.push Hotel.new(parse_hotel_information(hotel_data.to_json))
      end
      hotels
    end

    def self.hit(url)
      Net::HTTP.get_response(url).body
    end

    def self.parse_hotel_information(json)
      parsed = JSON.parse json
      handle_errors(parsed)
      summary = parsed["hotelId"] ? parsed : parsed["HotelInformationResponse"]["HotelSummary"]
      parsed_info = { id: summary["hotelId"], name: summary["name"], address: summary["address1"], city: summary["city"], postal_code: summary["postalCode"], country_code: summary["countryCode"], rating: summary["hotelRating"], high_rate: summary["highRate"], low_rate: summary["lowRate"], latitude: summary["latitude"].to_f, longitude: summary["longitude"].to_f }
      if images(parsed)
        parsed_info[:image_urls] = images(parsed)
      end
      parsed_info
    end

    def self.images(parsed)
      p parsed
      return nil
    end

    def self.handle_errors(info)
      raise EXCEPTIONS[info["HotelListResponse"]["EanWsError"]["exceptionConditionId"]] if info["HotelListResponse"] && info["HotelListResponse"]["EanWsError"]
      raise EXCEPTIONS[info["HotelInformationResponse"]["EanWsError"]["exceptionConditionId"]] if info["HotelInformationResponse"] && info["HotelInformationResponse"]["EanWsError"]
    end

    def self.split(data)
      parsed = JSON.parse(data)
      hotels = parsed["HotelListResponse"]["HotelList"]
      hotels["HotelSummary"]
    end

    def rooms(info)
      params = info
      params[:rooms].each_with_index do |room, n|
        params["room#{n+1}"] = (room[:children] == 0 ? "" : room[:children].to_s + ",").to_s + room[:ages].join(",").to_s
      end
      params["arrivalDate"] = info[:arrival]
      params["departureDate"] = info[:departure]
      params.delete(:arrival)
      params.delete(:departure)
      params["hotelId"] = @id
      parsed = JSON.parse(Hotel.hit(Hotel.url(:avail, true, true, params)))
      hotel_id = parsed["HotelRoomAvailabilityResponse"]["hotelId"]
      rate_key = parsed["HotelRoomAvailabilityResponse"]["rateKey"]
      supplier_type = parsed["HotelRoomAvailabilityResponse"]["HotelRoomResponse"][0]["supplierType"]
      Room.new(rate_key, hotel_id, supplier_type)
    end

    def payment_options
      options = []
      types_raw = JSON.parse Hotel.hit(Hotel.url(:paymentInfo, true, true, {}))
      types_raw["HotelPaymentResponse"].each do |raw|
        p raw
        types = raw[0] != "PaymentType" ? [] : raw[1]
        types.each do |type|
          options.push PaymentOption.new(type["code"], type["name"])
        end
      end
      options
    end
  end
end
