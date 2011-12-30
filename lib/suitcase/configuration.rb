module Suitcase
  class Configuration
    def self.cache=(store)
      @@cache = Suitcase::Cache.new(store)
    end

    def self.cache
      return @@cache if cache?
      nil
    end

    def self.cache?
      defined? @@cache
    end
  end
end
