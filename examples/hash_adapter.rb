class HashAdapter
  attr_accessor :hash

  def [](key)
    @hash[key]
  end

  def []=(key, value)
    @hash[key] = value
  end

  def keys
    @hash.keys
  end
end
