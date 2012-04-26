require 'spec_helper'

describe Suitcase::Reservation do
  before :all do
    @reservation = Suitcase::Reservation.new({})
  end

  subject { @reservation }
  it { should respond_to :itinerary_id }
  it { should respond_to :confirmation_numbers }
end
