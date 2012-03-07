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
  end
end
