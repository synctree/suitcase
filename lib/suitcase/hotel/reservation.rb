module Suitcase
  class Reservation
    attr_accessor :itinerary_id, :confirmation_number

    def initialize(info)
      @itinerary_id, @confirmation_number = info[:itinerary_id], info[:confirmation_number]
    end
  end
end
