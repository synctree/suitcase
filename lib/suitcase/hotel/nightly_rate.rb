module Suitcase
  class NightlyRate
    attr_accessor :promo, :rate, :base_rate

    def initialize(info)
      @promo = info["@promo"]
      @rate = info["@rate"]
      @base_rate = info["@baseRate"]
    end
  end
end
