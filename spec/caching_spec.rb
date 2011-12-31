require 'spec_helper'

describe Suitcase do
  before :all do
    Suitcase::Configuration.cache = {}
  end

  it "should cache all non-secure queries" do
    Suitcase::Hotel.find(id: 123904)
    Suitcase::Configuration.cache.keys.count.should eq(1)
  end

  it "should retrieve from the cache if it's there" do
    lambda do
      Object.send :remove_const, :Net # disable access to the API
      Suitcase::Hotel.find(id: 123904)
    end.should_not raise_error
  end
end
