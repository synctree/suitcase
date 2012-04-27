require 'spec_helper'

module Suitcase
  describe Amenity do
    describe ".parse_mask" do
      context "when provided bitmask is not nil or 0" do
        it "returns an array of symbols representing given amenities" do
          Amenity.parse_mask(5).should == [:business_services, :hot_tub]
        end
      end

      context "when provided bitmask is 0" do
        it "returns an empty array" do
          Amenity.parse_mask(0).should == []
        end
      end

      context "when provided bitmask is nil" do
        it "returns nil" do
          Amenity.parse_mask(nil).should == nil
        end
      end
    end
  end
end
