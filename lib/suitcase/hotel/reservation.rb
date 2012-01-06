module Suitcase
  class Reservation
    attr_accessor :itinerary_id, :confirmation_numbers

    def initialize(info)
      @itinerary_id, @confirmation_numbers = info[:itinerary_id], [info[:confirmation_numbers]].flatten
    end
  end
end
