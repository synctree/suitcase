require 'spec_helper'

describe Suitcase::Hotel::Location do
  describe '.find' do
    it 'should return an array of Locations' do
      locations = Suitcase::Hotel::Location.find(:destination_string => "Lond")
      locations.should be_an(Array)
      locations.first.should be_a(Suitcase::Hotel::Location)
    end
  end

  before :all do
    @location = Suitcase::Hotel::Location.new({})
  end

  subject { @location }

  [:destination_id, :province, :country, :country_code, :city, :type, :active].each do |attribute|
    it { should respond_to attribute }
  end
end
