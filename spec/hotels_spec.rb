require 'spec_helper'

describe Suitcase::Hotel do
  before :all do
    @hotel = Suitcase::Hotel.find(id: 123904)
  end

  describe "::find" do
    it "should locate a single Hotel if an id argument is passed" do
      @hotel.should be_a(Suitcase::Hotel)
    end

    it "should locate an Array of Hotels if an id argument is not passed" do
      hotels = Suitcase::Hotel.find(location: "London, UK")
      hotels.should be_an(Array)
      hotels.first.should be_a(Suitcase::Hotel)
    end
  end

  subject { @hotel }

  it { should respond_to :id }
  it { should respond_to :name }
  it { should respond_to :address }
  it { should respond_to :city }
  it { should respond_to :min_rate }
  it { should respond_to :max_rate }
  it { should respond_to :amenities }
  it { should respond_to :country_code }
  it { should respond_to :high_rate }
  it { should respond_to :low_rate }
  it { should respond_to :longitude }
  it { should respond_to :latitude }
  it { should respond_to :rating }
  it { should respond_to :postal_code }
  it { should respond_to :images }

  it "#images should return an Array of Suitcase::Image's" do
    images = @hotel.images
    images.should be_an(Array)
    lambda do
      images.map { |image| URI.parse image.url }
    end.should_not raise_error
  end

  describe "#rooms" do
    before :all do
      @info = { arrival: "6/23/2012", departure: "6/30/2012" }
    end

    subject do
      @hotel.rooms(@info)
    end

    it { should be_an(Array) }
  end
end
