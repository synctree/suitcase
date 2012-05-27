module Suitcase
  # Internal: Various methods for doing things that many files need to in the
  #           library.
  #
  # Examples
  #
  #   parameterize(something: "else", another: "thing")
  #   # => "something=else&another=thing"
  class Hotel
    module Helpers
      # Internal: Defaults for the builder options to Helpers#url.
      URL_DEFAULTS = {
        include_key: true,
        include_cid: true,
        secure: false,
        as_form: false,
        session: Session.new
      }

      # Internal: Parameterize a Hash.
      #
      # hash  - The Hash to be parameterized.
      #
      # Examples
      #
      #   parameterize(something: "else", another: "thing")
      #   # => "something=else&another=thing"
      #
      # Returns a parameterized String.
      def parameterize(hash)
        hash.map { |key, value| "#{key}=#{value}" }.join "&"
      end

      # Internal: Build an API URL.
      #
      # builder - A Hash with the following required keys:
      #           :method       - The API method to be put in the URL.
      #           :params       - The params to be put in the URL.
      #           And the following optional ones:
      #           :include_key  - Whether to include the API key or not.
      #           :include_cid  - Whether to include the API cid or not.
      #           :secure       - Whether or not for the request to be sent over
      #                           HTTPS.
      #           :as_form      - Whether or not to include the parameters in the
      #                           URL.
      #           :session      - The Session associated with the request.
      #
      # Examples
      #
      #   url(secure: true, as_form: true, method: "myMethod", params: {})
      #   # => #<URI::HTTPS URL:https://book.api.ean.com/.../rs/hotel/v3/myMethod>
      #
      # Returns the URI with the builder's information.
      def url(builder)
        builder = URL_DEFAULTS.merge(builder)
        builder[:session] ||= URL_DEFAULTS[:session]
        method, params = builder[:method], builder[:params]
        params["apiKey"] = Configuration.hotel_api_key if builder[:include_key]
        params["cid"] = (Configuration.hotel_cid ||= 55505) if builder[:include_cid]
        params["sig"] = generate_signature if Configuration.use_signature_auth?
        
        url = main_url(builder[:secure]) + method.to_s + (builder[:as_form] ? "" : "?")

        params.merge!(build_session_params(builder[:session]))
        url += parameterize(params) unless builder[:as_form]
        URI.parse(URI.escape(url))
      end

      # Internal: Get the root URL for the Hotels API.
      #
      # secure - Whether or not the URL should be HTTPS or not.
      #
      # Returns the URL.
      def main_url(secure)
        url = "http#{secure ? "s" : ""}://#{secure ? "book." : ""}"
        url += "api.ean.com/ean-services/rs/hotel/v3/"
        url
      end

      # Internal: Parse the JSON response at the given URL.
      #
      # uri - The URI to parse the JSON from.
      #
      # Returns the parsed JSON.
      def parse_response(uri)
        JSON.parse(Net::HTTP.get_response(uri).body)
      end

      # Internal: Get the base URL based on a Hash of info.
      #
      # info  - A Hash with only one required key:
      #         :booking - Whether or not it is a booking request.
      #
      # Returns the base URL.
      def base_url(info)
        main_url(info[:booking])
      end

      # Internal: Build a Hash of params from a Session.
      #
      # session - The Session to generate params from.
      #
      # Returns the Hash of params.
      def build_session_params(session)
        session_info = {}
        session_info["customerSessionId"] = session.id if session.id
        session_info["customerIpAddress"] = session.ip_address if session.ip_address
        session_info["locale"] = session.locale if session.locale
        session_info["currencyCode"] = session.currency_code if session.currency_code
        session_info["customerUserAgent"] = session.user_agent if session.user_agent
        session_info
      end

      # Internal: Update the Session's ID with the parsed JSON.
      #
      # parsed  - The parsed JSON to fetch the ID from.
      # session - The Session to update.
      #
      # Returns nothing.
      def update_session(parsed, session)
        session ||= Session.new
        session.id = parsed[parsed.keys.first]["customerSessionId"] if parsed[parsed.keys.first]
      end

      # Internal: Generate a digital signature to authenticate with.
      #
      # Returns the generated signature.
      def generate_signature
        Digest::MD5.hexdigest(Configuration.hotel_api_key + 
                              Configuration.hotel_shared_secret + 
                              Time.now.to_i.to_s)
      end
    end
  end
end
