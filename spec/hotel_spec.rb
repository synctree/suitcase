require 'spec_helper'

include Suitcase

describe Hotel do
  before(:each) do
    @attr = { :near => "Boston", :results => 50 }
  end

  describe "find method" do
    it "should return the correct number of results" do
      Hotel.find(@attr).count.should eq(50)
    end

    it "should return an array of hotels" do
      Hotel.find(@attr).class.should eq(Array)
    end

    it "should return all hotels" do
      Hotel.find(@attr).map { |x| x.class }.should eq([Hotel] * 50)
    end
  end
end
