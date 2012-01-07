module Suitcase
  class Configuration
    def self.cache=(store)
      @@cache = Suitcase::Cache.new(store)
    end

    def self.cache
      return @@cache if cache?
    end

    def self.cache?
      defined? @@cache
    end

    def self.hotel_api_key=(key)
      @@hotel_api_key = key
    end

    def self.hotel_api_key
      @@hotel_api_key
    end

    def self.hotel_cid=(cid)
      @@hotel_cid = cid
    end

    def self.hotel_cid
      @@hotel_cid if defined? @@hotel_cid
    end

    def self.session_cache=(store)
      @@session_cache = Suitcase::SessionCache.new(store)
    end
    
    def self.session_cache
      return @@session_cache if session_cache?
    end

    def self.session_cache?
      defined? @@session_cache
    end
  end
end
