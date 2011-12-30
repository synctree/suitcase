module Suitcase
  class NightlyRate
    attr_accessor :promo, :rate, :base_rate

    def initialize(info)
      promo = info["@promo"]
      promo = info["@rate"]
      promo = info["@baseRate"]
    end
  end
end
