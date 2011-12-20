require 'open-uri'
require 'json'
require 'nokogiri'
require File.dirname(__FILE__) + '/../airport_codes'

module Suitcase
  class Flight
    attr_accessor :flights, :key, :origin, :destination, :departure, :arrival, :adults, :children, :seniors, :fare, :direct, :round_trip, :currency, :search_window, :results, :airline, :airline_code, :price, :segments, :outgoing

    # Public: Convert the flight to a string representation.
    #
    # Examples:
    #
    # puts @flight
    # ----------
    # FLIGHT:
    # airline: USA (313)
    # origin: Boston
    # destination: New York
    # departure: 2:00
    # arrival: 4:00
    # price: 300 ($)
    # key: 57a034
    # ----------
    def to_s
      puts <<EOS
----------
FLIGHT:
airline: #{airline} (#{airline_code})
origin: #{origin}
destination: #{destination}
departure: #{departure}
arrival: #{arrival}
price: #{price} (#{currency})
key: #{key}
----------
EOS
    end

    def self.available(data)
      origin_city = data[:from]
      destination_city = data[:to]
      departure_date_time = data[:departs]
      arrival_date_time = data[:arrives]
      adult_passengers = data[:adults] ? data[:adults] : 0
      child_passengers = data[:children] ? data[:children].inject("") { |result, element| result + "C" + (element < 10 ? "0" : "") + element.to_s + (data[:children].last == element ? "" : ",") } : "" # :children => [2, 9, 11] (ages of children) should yield "C02,C09,C11"
      senior_passengers = data[:seniors] ? data[:seniors] : 0
      fare_class = data[:fare] ? data[:fare] : "Y" # F: first class; Y: coach; B: business
      direct_flight = data[:direct_only] ? data[:direct_only] : false
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
      uri = URI.escape("http://api.ean.com/ean-services/rs/air/200919/xmlinterface.jsp?cid=#{CID}&resType=air&intfc=ws&apiKey=#{API_KEY}&xml=#{xml_format}")
      xml = Nokogiri::XML(open(uri))
      segments = []
      xml.xpath('//Segment').each do |segment|
        f = Flight.new
        f.key = segment.xpath("@key")
        f.origin = segment.xpath("//originCity") + segment.xpath("//originStateProvince") + segment.xpath("//originCountry")
        f.destination = segment.xpath("//destinationCity")
        f.airline = segment.xpath("//airline")
        f.airline_code = segment.xpath("//airlineCode")
        f.departure = segment.xpath("//departureDateTime")
        f.arrival = segment.xpath("//arrivalDateTime")
        segments.push(f)
      end
      flights = []
      xml.xpath("//AirAvailabilityReply").each do |aar|
        f = Flight.new
        f.segments = []
        f.price = aar.xpath("//nativeTotalPrice")
        f.currency = aar.xpath("//displayCurrencyCode")
        aar.xpath("//FlightSegment").each do |subseg|
          fn = segments.find { |x| x.key == subseg.xpath("//segmentKey") }
          f.segments.push(fn)
          f.segments.compact!
        end
        flights.push(f)
      end
      flights
    end
  end
end
