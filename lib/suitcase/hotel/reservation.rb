module Suitcase
  class Hotel
    class Reservation
      attr_accessor :itinerary_id, :confirmation_numbers

      # Internal: Create a new Reservation from the API response.
      #
      # info - The Hash of information returned from the API.
      def initialize(info)
        @itinerary_id, @confirmation_numbers = info[:itinerary_id], [info[:confirmation_numbers]].flatten
      end
    end
  end
end
