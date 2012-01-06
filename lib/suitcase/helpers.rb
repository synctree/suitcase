module Suitcase
  module Helpers
    def url(method, params, include_key=true, include_cid=true, secure=false, as_form=false)
      params["apiKey"] = Configuration.hotel_api_key if include_key
      params["cid"] = (Configuration.hotel_cid ||= 55505) if include_cid
      url = main_url(secure) + method.to_s + (as_form ? "" : "?")
      url += params.map { |key, value| "#{key}=#{value}"}.join("&")
      URI.parse(URI.escape(url))
    end

    def main_url(secure)
      "http#{secure ? "s" : ""}://#{secure ? "book." : ""}api.ean.com/ean-services/rs/hotel/v3/"
    end

    def parse_response(uri)
      JSON.parse(Net::HTTP.get_response(uri).body)
    end

    def base_url(info)
      if info[:booking]
        URI.parse main_url(true)
      else
        URI.parse main_url(false)
      end
    end
  end
end
