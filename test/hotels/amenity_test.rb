require "minitest_helper"

describe Suitcase::Amenity do
  describe ".parse_mask" do
    describe "when provided bitmask is not nil or 0" do
      it "returns an Array of Symbols representing given Amenities" do
        Suitcase::Amenity.parse_mask(5).must_equal [:business_services, :hot_tub]
      end
    end

    describe "when bitmask is 0" do
      it "returns an empty Array" do
        Suitcase::Amenity.parse_mask(0).must_equal []
      end
    end

    describe "when provided bitmask is nil" do
      it "returns nil" do
        Suitcase::Amenity.parse_mask(nil).must_equal nil
      end
    end
  end  
end