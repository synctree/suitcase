module Suitcase
  class Session
    attr_accessor :locale, :currency_code, :session_id, :ip_address, :user_agent

    # Public: Instantiate a new session
    #
    # info -  a Hash of the attributes:
    #         - locale: the user's locale
    #         - currency_code: the user's currency code
    #         - session_id: the session_id
    #         - ip_address: the user's IP address (request.remote_ip)
    #         - user_agent: the user's user agent
    def initialize(info={})
      %w(locale currency_code session_id ip_address user_agent).each do |attr|
        send (attr + "=").to_sym, info[attr.to_sym]
      end
      Suitcase::Configuration.session_cache.push self
    end

    def delete(session_id)
      Session.store.delete Session.store.find { |session| session.session_id == session_id }
    end

    def find_or_create(info)
      session = Session.store.find { |session| session.session_id == session_id }
      session = Session.new(info) unless session
      session
    end
    
    def self.store
      Suitcase::Configuration.session_store
    end
  end
end
