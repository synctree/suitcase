require 'net/http'
require 'uri'
require 'json'
require File.dirname(__FILE__) + '/../airport_codes'

module Suitcase
  class Flight
    attr_accessor :origin, :destrination, :departure, :arrival, :adults, :children, :seniors, :fare, :direct, :round_trip, :currency, :search_window, :results

    def self.available(data)
      origin_city = data[:origin]
      destination_city = data[:destination]
      departure_date_time = data[:departure]
      arrival_date_time = data[:arrival]
      adult_passengers = data[:adults] ? data[:adults] : 0
      child_passengers = data[:children] ? data[:children].inject("") { |result, element| result + "C" + (element < 10 ? "0" : "") + element.to_s + (data[:children].last == element ? "" : ",") } : "" # :children => [2, 9, 11] (ages of children) should yield "C02,C09,C11"
      senior_passengers = data[:seniors] ? data[:seniors] : 0
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
    <returnDateTime>#{arrival_date_time}</returnDateTime>
    <fareClass>#{fare_class}</fareClass>
    <tripType>#{round_trip}</tripType>
    <Passengers>
      <adultPassengers>#{adult_passengers}</adultPassengers>
      <seniorPassengers>#{senior_passengers}</seniorPassengers>
      <childCodes>#{child_passengers}</childCodes>
    </Passengers>
  </AirAvailabilityQuery>
</AirSessionRequest>
EOS
      puts xml_format
    end
  end
end

include Suitcase
Flight.available(:origin => "BOS", :destination => "LHR", :departure => "1/6/2012 11:00 AM", :arrival => "1/7/12 1:00 AM", :adults => 2, :children => [9, 11, 13], :search_window => 5)
