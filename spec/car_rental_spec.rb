require 'spec_helper'

describe Suitcase::CarRental do
  before :each do
    @rentals = Suitcase::CarRental.find(destination: "Seattle", start_date: "07/04/2012", end_date: "07/11/2012", pickup_time: "07:30", dropoff_time: "07:30")
  end

  describe '.find' do 
    it 'returns an Array of CarRentals' do
      @rentals.class.should eq Array
      @rentals.first.class.should eq Suitcase::CarRental
    end
  end

  subject { @rentals.first }

  [:seating, :type_name, :type_code, :possible_features, :possible_models].each do |method|
    it { should respond_to method }
  end
end
