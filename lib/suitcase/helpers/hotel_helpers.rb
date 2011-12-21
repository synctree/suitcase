module Suitcase
  module HotelHelpers
    include Suitcase::DataHelpers

    def hotel_list(info)
      info["destinationstring"] = info[:destination]
      info.delete(:destination)
      parse(url(:hotel, :list, true, info))
    end

    def parse_hotel_info(info)
      if error_free?(info)
        info["HotelListResponse"]["HotelList"]
      else
        return { errors: info["HotelListResponse"]["EanWsError"] }
      end
    end

    def error_free?(info)
      !info["HotelListResponse"]["EanWsError"].empty?
    end
  end
end
