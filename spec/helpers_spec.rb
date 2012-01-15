require 'spec_helper'

describe Suitcase::Helpers do
  before :each do
    class Dummy; extend Suitcase::Helpers; end
  end

  it "#url should return a URI with the correct base URL" do
    returned = Dummy.url(:method => "action", :params => {})
    returned.should be_a(URI)
    returned.host.should match(/api.ean.com/)
  end

  it "#parse_response should raise an exception when passed an invalid URI" do
    lambda do
      Dummy.parse_response(URI.parse "http://google.com")
    end.should raise_error
  end
end
