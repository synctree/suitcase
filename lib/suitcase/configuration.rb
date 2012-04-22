module Suitcase
  def self.configure(&block)
    block.call(Configuration)
  end

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

    def self.hotel_shared_secret=(secret)
      @@hotel_shared_secret = secret
    end

    def self.hotel_shared_secret
      @@hotel_shared_secret if defined? @@hotel_shared_secret
    end

    def self.use_signature_auth=(choice)
      @@use_signature_authentication = choice
    end

    def self.use_signature_auth?
      defined? @@use_signature_auth
    end

    def self.hotwire_api_key=(api_key)
      @@hotwire_api_key = api_key
    end

    def self.hotwire_api_key
      @@hotwire_api_key if defined? @@hotwire_api_key
    end

    def self.hotwire_linkshare_id=(id)
      @@hotwire_linkshare_id = id
    end

    def self.hotwire_linkshare_id
      @@hotwire_linkshare_id if use_hotwire_lnikshare_id?
    end

    def self.use_hotwire_linkshare_id?
      defined? @@hotwire_linkshare_id
    end
  end
end
