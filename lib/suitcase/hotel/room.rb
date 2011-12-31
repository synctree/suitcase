module Suitcase
  class Room
    attr_accessor :rate_key, :hotel_id, :supplier_type, :rate_code, :room_type_code, :supplier_type, :tax_rate, :non_refundable, :occupancy, :quoted_occupancy, :min_guest_age, :total, :surcharge_total, :nightly_rate_total, :average_base_rate, :average_rate, :max_nightly_rate, :currency_code, :value_adds, :room_type_description, :price_breakdown, :total_price, :average_nightly_rate, :promo, :arrival, :departure

    def initialize(info)
      info.each do |k, v|
        instance_variable_set("@" + k.to_s, v)
      end
    end

    def reserve!(info)
      params = info
      params["hotelId"] = @hotel_id
      params["arrivalDate"] = @arrival
      params["departureDate"] = @departure
      params["supplierType"] = @supplier_type
      params["rateKey"] = @rate_key
      params["rateTypeCode"] = @room_type_code
      params["rateCode"] = @rate_code
      params["chargeableRate"] = chargeable_rate      
    end

    def chargeable_rate
      case @supplier_type == "E"
      when true
        @total
      when false
        @max_nightly_rate
      end
    end
  end
end
