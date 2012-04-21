module Suitcase
  module Helpers
    URL_DEFAULTS = {
      include_key: true,
      include_cid: true,
      secure: false,
      as_form: false,
      session: Session.new
    }

    def parameterize(hash)
      hash.map { |key, value| "#{key}=#{value}" }.join "&"
    end

    def url(builder)
      builder = URL_DEFAULTS.merge(builder)
      builder[:session] ||= URL_DEFAULTS[:session]
      method, params = builder[:method], builder[:params]
      params["apiKey"] = Configuration.hotel_api_key if builder[:include_key]
      params["cid"] = (Configuration.hotel_cid ||= 55505) if builder[:include_cid]
      params["sig"] = generate_signature if Configuration.use_signature_auth?
      
      url = main_url(builder[:secure]) + method.to_s + (builder[:as_form] ? "" : "?")

      params.merge!(build_original_session(builder[:session]))
      url += parameterize(params) unless builder[:as_form]
      URI.parse(URI.escape(url))
    end

    def main_url(secure)
      "http#{secure ? "s" : ""}://#{secure ? "book." : ""}api.ean.com/ean-services/rs/hotel/v3/"
    end

    def parse_response(uri)
      JSON.parse(Net::HTTP.get_response(uri).body)
    end

    def base_url(info)
      main_url(info[:booking])
    end

    def build_original_session(session)
      session_info = {}
      session_info["customerSessionId"] = session.id if session.id
      session_info["customerIpAddress"] = session.ip_address if session.ip_address
      session_info["locale"] = session.locale if session.locale
      session_info["currencyCode"] = session.currency_code if session.currency_code
      session_info["customerUserAgent"] = session.user_agent if session.user_agent
      session_info
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
