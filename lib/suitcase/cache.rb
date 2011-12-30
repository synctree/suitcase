module Suitcase
  class Cache
    def initialize(store)
      @store = store
    end

    def save_query(action, params, response)
      params.delete("apiKey")
      params.delete("cid")
      @store[action] ||= {}
      @store[action][params] = response
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
  end
end
