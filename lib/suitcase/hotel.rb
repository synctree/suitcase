module Suitcase
  class Hotel
    def initialize(info)
      info.each do |k, v|
        instance_variable_set("@#{k}", v)
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
        amenities = ""
        params[:amenities].each do |amenity|
          amenities += amenities + ","
        end
        if amenities =~ /^(.+),$/
          amenities = $1
        end
      end
      params[:amenities] = amenities
      hotels = []
      split(hit(url(:list, true, true, params))).each do |hotel_data|
        p hotel_data.to_json
        hotels.push Hotel.new(parse_hotel_information(hotel_data.to_json))
      end
      hotels
    end

    def self.hit(url)
      Net::HTTP.get_response(url).body
    end

    def self.parse_hotel_information(json)
      parsed = JSON.parse json
      summary = parsed["hotelId"] ? parsed : parsed["HotelInformationResponse"]["HotelSummary"]
      { id: summary["HotelId"], name: summary["name"], address: summary["address1"], city: summary["city"], postal_code: summary["postalCode"], country_code: summary["countryCode"], rating: summary["hotelRating"], high_rate: summary["highRate"], low_rate: summary["lowRate"], latitude: summary["latitude"].to_f, longitude: summary["longitude"].to_f }
    end

    def self.split(data)
      parsed = JSON.parse(data)
      hotels = parsed["HotelListResponse"]["HotelList"]
      hotels["HotelSummary"]
    end
  end
end
