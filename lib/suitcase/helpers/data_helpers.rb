module Suitcase
  module DataHelpers
    def url(api, action, include_key=true, params={})
      case api
      when :hotel
        url = "http://api.ean.com/ean-services/rs/hotel/v3/" + action.to_s + "?"
      when :air
        url = ""
      when :car
        url = ""
      end
      include_key ? params["apiKey"] = const_get(api.to_s.capitalize)::API_KEY : nil
      params.each do |key, value|
        url += key.to_s + "=" + value.to_s + "&"
      end
      if url =~ /^(.+)&$/
        url = $1
      end
      return URI.escape url
    end
  end
end
