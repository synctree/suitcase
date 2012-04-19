module Suitcase
  module Helpers
    def url(builder)
      builder[:include_key] ||= true
      builder[:include_cid] ||= true
      builder[:secure] ||= false
      builder[:as_form] ||= false
      builder[:session] ||= Suitcase::Session.new
      method, params, include_key, include_cid = builder[:method], builder[:params], builder[:include_key], builder[:include_cid]
      params["apiKey"] = Configuration.hotel_api_key if include_key
      params["cid"] = (Configuration.hotel_cid ||= 55505) if include_cid
      if Configuration.use_signature_auth?
        params["sig"] = generate_signature
      end
      url = main_url(builder[:secure]) + method.to_s + (builder[:as_form] ? "" : "?")
      session_info = {}
      session_info["customerSessionId"] = builder[:session].id if builder[:session].id
      session_info["customerIpAddress"] = builder[:session].ip_address if builder[:session].ip_address
      session_info["locale"] = builder[:session].locale if builder[:session].locale
      session_info["currencyCode"] = builder[:session].currency_code if builder[:session].currency_code
      session_info["customerUserAgent"] = builder[:session].user_agent if builder[:session].user_agent
      url += params.merge(session_info).map { |key, value| "#{key}=#{value}"}.join("&") unless builder[:as_form]
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

    def update_session(parsed, session)
      session ||= Suitcase::Session.new
      session.id = parsed[parsed.keys.first]["customerSessionId"] if parsed[parsed.keys.first]
    end

    def generate_signature
      Digest::MD5.hexdigest(Configuration.hotel_api_key + 
                            Configuration.hotel_shared_secret + 
                            Time.now.to_i.to_s)
    end
  end
end
