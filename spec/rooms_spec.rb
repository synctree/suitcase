require 'spec_helper'

describe Suitcase::Room do
  before :all do
    @room = Suitcase::Hotel.find(id: 123904).rooms(arrival: "6/23/2012", departure: "6/30/2012")
  end

  subject { @room }
  it { should respond_to :reserve! }
  
  describe "#reserve!" do
    before :all do
      
    end

    it "should respond to a Hash of arguments" do
      
    end
  end
end

describe Suitcase::RoomGroup do
  before :all do
    @room_group = Suitcase::Hotel.find(id: 123904).rooms(arrival: "6/23/2012", departure: "6/30/2012")
  end

  subject { @room_group }

  it { should respond_to :rooms }
  it "#rooms should return an Array" do
    @room_group.rooms.should be_an(Array)
  end
end
