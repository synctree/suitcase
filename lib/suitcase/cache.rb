module Suitcase
  class Cache
    attr_accessor :store

    def initialize(store)
      @store = store
    end

    def save_query(action, params, response)
      %w(apiKey cid customerSessionId customerIpAddress locale customerUserAgent).each do |param|
        params.delete(param)
      end
      params.delete("currencyCode") unless action == :paymentInfo
      @store[action] ||= {}
      @store[action] = @store[action].merge(params => response)
    end

    def get_query(action, params)
      @store[action] ? @store[action][params] : nil
    end

    def keys
      @store.keys
    end

    def cached?(action, params)
      @store[action] && @store[action][params]
    end

    def undefine_query(action, params)
      @store[action].delete(params) if @store[action]
    end
  end
end
