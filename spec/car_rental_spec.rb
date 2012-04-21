require 'spec_helper'

describe Suitcase::CarRental do
  describe '.find' do
    before :each do
      @rentals = Suitcase::CarRental.find(destination: "Seattle", start_date: "07/04/2012", end_date: "07/11/2012", pickup_time: "07:30", dropoff_time: "07:30")
    end
    
    it 'returns an Array of CarRentals' do
      @rentals.class.should eq Array
      @rentals.first.class.should eq Suitcase::CarRental
    end
  end
end
