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

    it "should locate an Array of Hotels if an ids argument is passed" do
      hotels = Suitcase::Hotel.find(:ids => [123904, 191937, 220166])
      hotels.should be_an(Array)
      hotels.first.should be_a(Suitcase::Hotel)
      hotels.count.should eq(3)
    end

    it "should locate an Array of Hotels if an ids argument is passed with a single id" do
      hotels = Suitcase::Hotel.find(:ids => [123904])
      hotels.should be_an(Array)
      hotels.first.should be_a(Suitcase::Hotel)
      hotels.count.should eq(1)
    end
  end

  subject { @hotel }

  it { should respond_to :id }
  it { should respond_to :name }
  it { should respond_to :address }
  it { should respond_to :city }
  it { should respond_to :amenities }
  it { should respond_to :masked_amenities }
  it { should respond_to :country_code }
  it { should respond_to :high_rate }
  it { should respond_to :low_rate }
  it { should respond_to :longitude }
  it { should respond_to :latitude }
  it { should respond_to :rating }
  it { should respond_to :postal_code }
  it { should respond_to :images }
  it { should respond_to :thumbnail_url }
  it { should respond_to :nightly_rate_total }
  it { should respond_to :property_description }
  it { should respond_to :number_of_floors }
  it { should respond_to :number_of_rooms }
  it { should respond_to :deep_link }
  it { should respond_to :tripadvisor_rating }

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
