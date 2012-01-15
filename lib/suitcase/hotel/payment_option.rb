module Suitcase
  class PaymentOption
   attr_accessor :code, :name
   extend Suitcase::Helpers

    def initialize(code, name)
      @code = code
      @name = name
    end

    def self.find(info)
      params = { "currencyCode" => info[:currency_code] }
      if Configuration.cache? and Configuration.cache.cached?(:paymentInfo, params)
        types_raw = Configuration.cache.get_query(:paymentInfo, params)
      else
        types_raw = parse_response(url(:method => "paymentInfo", :params => params, :session => info[:session]))
        Configuration.cache.save_query(:paymentInfo, params, types_raw) if Configuration.cache?      
      end
      options = []
      types_raw["HotelPaymentResponse"].each do |raw|
        types = raw[0] != "PaymentType" ? [] : raw[1]
        types.each do |type|
          options.push PaymentOption.new(type["code"], type["name"])
        end
      end
      update_session(types_raw, info[:session])
      options
    end
  end
end
