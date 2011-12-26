module Suitcase
  class Room
    attr_accessor :rate_key, :hotel_id, :supplier_type

    def initialize(rate_key, hotel_id, supplier_type)
      @rate_key = rate_key
      @hotel_id = hotel_id
      @supplier_type = supplier_type
    end

    def reserve!(info)
      params = info
      params["hotelId"] = @id
      params["arrivalDate"] = info[:arrival]
      params["departureDate"] = info[:departure]
      params.delete(:arrival)
      params.delete(:departure)
      params["supplierType"] = supplier_type
      params["rateKey"] = @rate_key
      params["rateTypeCode"] = info[:room_type_code]
      params["rateCode"] = info[:rate_code]
      params.delete(:rate_code)
      p Hotel.shove(Hotel.url(:res, true, true, {}, :post, true), params)
    end
  end
end
