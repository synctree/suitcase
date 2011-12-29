require 'spec_helper'

describe Suitcase::Hotel do
  it "::find should locate a single Hotel if an id argument is passed" do
    Suitcase::Hotel.find(id: 224955).should be_a(Suitcase::Hotel)
  end

  it "::find should locate an Array of Hotels if an id argument is not passed" do
    hotels = Suitcase::Hotel.find(location: "London, UK")
    hotels.should be_an(Array)
    hotels.first.should be_a(Suitcase::Hotel)
  end

  context "methods on a Hotel" do
    before :all do
      @hotel = Suitcase::Hotel.find(id: 224955)
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
    it { should respond_to :image_urls }
  end
end
