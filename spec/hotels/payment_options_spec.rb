require 'spec_helper'

describe Suitcase::PaymentOption do
  before :all do
    @info = { currency_code: "USD" }
  end

  it "::find should return an Array of PaymentOptions" do
    options = Suitcase::PaymentOption.find(@info)
    options.should be_an(Array)
    options.find_all { |opt| opt.class == Suitcase::PaymentOption }.count.should eq(options.count) # It should be an Array of PaymentOption's
  end
end
