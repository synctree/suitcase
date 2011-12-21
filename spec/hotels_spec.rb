require 'spec_helper'

describe Suitcase::Hotel do
  it "::find should return an Array if no ID is passed" do
    Suitcase::Hotel.find(destination: "Boston, US").should be_a(Array)
  end
end
