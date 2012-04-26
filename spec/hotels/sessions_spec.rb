require 'spec_helper'

describe Suitcase::Session do
  it { should respond_to :id }
  it { should respond_to :ip_address }
  it { should respond_to :user_agent }
  it { should respond_to :locale }
  it { should respond_to :currency_code }

  before :each do
    @s = Suitcase::Session.new
  end

  it "should be able to be passed in to a Hotel.find_by_id query" do
    Suitcase::Hotel.find(id: 123904, session: @s)
    @s.id.should_not be_nil
  end

  it "should be able to be passed in to a Hotel.find_by_info query" do
    Suitcase::Hotel.find(location: "Boston, US", session: @s)
    @s.id.should_not be_nil
  end

  it "should be able to be passed in to a Hotel#rooms query" do
    hotel = Suitcase::Hotel.find(id: 123904, session: @s)
    hotel.rooms(arrival: "6/23/2012", departure: "6/25/2012", session: @s)
    @s.id.should_not be_nil
  end

  it "should be able to be passed in to a Room#reserve! query" do
    hotel = Suitcase::Hotel.find(id: 123904, session: @s)
    room = hotel.rooms(arrival: "6/23/2012", departure: "6/25/2012", session: @s).first
    room.rooms[0][:bed_type] = room.bed_types[0]
    room.rooms[0][:smoking_preference] = "NS"
    room.reserve! Keys::VALID_RESERVATION_INFO
    @s.id.should_not be_nil
  end

  it "should be able to be passed in to a PaymentOption.find query" do
    payment_options = Suitcase::PaymentOption.find(currency_code: "USD", session: @s)
    @s.id.should_not be_nil
  end
end
