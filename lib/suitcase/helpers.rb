module Suitcase
  module Helpers
    def url(method, params, include_key=true, include_cid=true, secure=false, as_form=false)
      params["apiKey"] = Suitcase::Hotel::API_KEY if include_key
      params["cid"] = (defined? Suitcase::Hotel::CID ? Suitcase::Hotel::CID : 55505) if include_cid
      url = "http#{secure ? "s" : ""}://api.ean.com/ean-services/rs/hotel/v3/#{method.to_s}#{as_form ? "" : "?"}"
      url += params.map { |key, value| "#{key}=#{value}"}.join("&")
      URI.parse(URI.escape(url))
    end

    def parse_response(uri)
      JSON.parse(Net::HTTP.get_response(uri).body)
    end
  end
end
