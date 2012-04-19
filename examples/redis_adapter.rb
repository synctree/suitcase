class RedisAdapter
  def initialize
    uri = URI.parse(ENV["REDIS_URI"])
    @redis = Redis.new(:host => uri.host, 
                       :port => uri.port, 
                       :password => uri.password)
  end

  def [](key)
    stored = @redis.hgetall("ean_cache:#{key}")
    stored.inject({}) {|mem, (k, v)|
      mem[JSON.parse(k)] = JSON.parse(v)
      mem
    }
  end

  def []=(key, value)
    value.each_pair do |params, response|
      @redis.hset("ean_cache:#{key}", params.to_json, response.to_json)
    end
  end

  def keys
    @redis.keys("ean_cache:*").collect {|key|
      key.match(/ean_cache:(.*)/)[1] rescue nil
    }.compact!
  end
end

