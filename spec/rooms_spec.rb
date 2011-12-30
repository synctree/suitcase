require 'spec_helper'

describe Suitcase::Room do
  before :all do
    @room = Suitcase::Hotel.find(id: 123904).rooms(arrival: "6/23/2012", departure: "6/30/2012")
  end

  subject { @room }
  it { should respond_to :reserve! }
  it "#reserve! should take a Hash of options" do
    
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
