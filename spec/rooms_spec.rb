require 'spec_helper'

describe Suitcase::Room do
  before :all do
    @room = Suitcase::Hotel.find(id: 123904).rooms(arrival: "6/23/2012", departure: "6/30/2012").first
  end

  subject { @room }
  it { should respond_to :reserve! }
  it { should respond_to :arrival }
  it { should respond_to :departure }
  it { should respond_to :rate_code }
  it { should respond_to :room_type_code }
  it { should respond_to :supplier_type }
  it { should respond_to :tax_rate }
  it { should respond_to :non_refundable }
  it { should respond_to :occupancy }
  it { should respond_to :quoted_occupancy }
  it { should respond_to :min_guest_age }
  it { should respond_to :total }
  it { should respond_to :surcharge_total }
  it { should respond_to :nightly_rate_total }
  it { should respond_to :average_base_rate }
  it { should respond_to :average_rate }
  it { should respond_to :max_nightly_rate }
  it { should respond_to :currency_code }
  it { should respond_to :value_adds }
  it { should respond_to :room_type_description }
  it { should respond_to :price_breakdown }
  it { should respond_to :total_price }
  it { should respond_to :average_nightly_rate }
  it { should respond_to :promo }
  it { should respond_to :rate_key }
  it { should respond_to :hotel_id }
  it { should respond_to :supplier_type }
  describe "#reserve!" do
    before :all do
      
    end

    it "should respond to a Hash of arguments" do
      
    end
  end
end
