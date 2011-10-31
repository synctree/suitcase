require 'net/http'
require 'uri'
require 'json'

module Suitcase
  class Flight
    attr_accessor :origin, :destrination, :departure, :arrival, :adults, :children, :seniors, :fare, :direct, :round_trip, :currency, :search_window, :results

    def self.available(data)
      origin_city = city_codes[data[:origin]]
      destination_city = city_codes[data[:destination]]
      departure_date_time = data[:departure]
      arrival_date_time = data[:arrival]
      adult_passengers = data[:adults]
      child_passengers = data[:children]
      senior_passengers = data[:seniors]
      fare_class = data[:fare] ? data[:fare] : "Y" # F: first class; Y: coach; B: business
      direct_flight = data[:direct] ? data[:direct] : false
      round_trip = data[:round_trip] ? data[:round_trip] : "O"
      currency = data[:currency] ? data[:currency] : "USD"
      search_window = data[:search_window] ? data[:search_window] : 2
      number_of_results = data[:results] ? data[:results] : 50
      xml_format = <<EOS
      <AirSessionRequest method="getAirAvailability">
        <AirAvailabilityQuery>
          <originCityCode>#{origin_city}</originCityCode>
          <destinationCityCode>#{destination_city}</destinationCityCode>
          <departureDateTime>#{departure_date_time}</departureDateTime>
          <returnDateTime>#{return_date_time}</returnDateTime>
          <fareClass>#{fare_class}</fareClass>
          <tripType>#{round_trip}</tripType>
          <Passengers>
            <seniorPassengers>#{senior_passengers}</seniorPassengers>
            <childCodes>#{child_passengers}</childCodes>
          </Passengers>
        </AirAvailabilityQuery>
      </AirSessionRequest>
      EOS
    end
  end
end
