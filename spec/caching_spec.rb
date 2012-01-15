require 'spec_helper'

describe Suitcase do
  before :all do
    Suitcase::Configuration.cache = {}
  end

  it "should cache all non-secure queries" do
    hotel = Suitcase::Hotel.find(id: 123904)
    Suitcase::Hotel.find(location: "Boston, US")
    room = hotel.rooms(arrival: "6/23/2012", departure: "6/30/2012").first
    Suitcase::PaymentOption.find currency_code: "USD"
    room.rooms[0][:bed_type] = room.bed_types[0]
    room.rooms[0][:smoking_preference] = "NS"
    room.reserve!(Keys::VALID_RESERVATION_INFO) # We don't want to cache this
    Suitcase::Configuration.cache.keys.count.should eq(4)
  end

  it "should retrieve from the cache if it's there" do
    hotel = Suitcase::Hotel.find(id: 123904)
    Suitcase::Hotel.find(location: "Boston, US")
    hotel.rooms(arrival: "6/23/2012", departure: "6/30/2012")
    Suitcase::PaymentOption.find currency_code: "USD"
    lambda do
      Net::HTTP.stub!(:get_response).and_return nil # disable access to the API
      hotel = Suitcase::Hotel.find(id: 123904)
      Suitcase::Hotel.find(location: "Boston, US")
      hotel.rooms(arrival: "6/23/2012", departure: "6/30/2012")
      Suitcase::PaymentOption.find currency_code: "USD"
    end.should_not raise_error
  end
end
