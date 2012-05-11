require "minitest_helper"

describe Suitcase::PaymentOption do
  before :each do
    @info = { currency_code: "USD" }
  end
  
  describe ".find" do
    it "returns an Array of PaymentOption's" do
      options = Suitcase::PaymentOption.find(@info)
      options.must_be_kind_of(Array)
      options.first.must_be_kind_of(Suitcase::PaymentOption)
    end
  end
end