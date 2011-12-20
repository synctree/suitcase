require 'spec_helper'

describe Suitcase::DataHelpers do
  before :each do
    class Hotel
      API_KEY = HOTEL_API_KEY
      extend Suitcase::DataHelpers
    end
  end

  it "#url should return a valid url" do
    URI.parse(Hotel.url(:hotel, :list, true, { location: "London, UK" })).should be_a(URI)
  end
end
