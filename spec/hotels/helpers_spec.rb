require 'spec_helper'

describe Suitcase::Helpers do
  before :each do
    class Dummy; extend Suitcase::Helpers; end
  end

  describe "#url" do
    it "should return a URI with the correct base URL" do
      returned = Dummy.url(:method => "action", :params => {})
      returned.should be_a(URI)
      returned.host.should match(/api.ean.com/)
    end

    context "when using digital signature authentication" do
      it "should add a 'sig' parameter" do
        Suitcase::Configuration.stub(:use_signature_auth?) { true }
        Dummy.stub(:generate_signature) { "test" }

        returned = Dummy.url(:method => "action", :params => {})
        returned.query.should match(/sig=test/)
      end
    end
  end

  it "#parse_response should raise an exception when passed an invalid URI" do
    lambda do
      Dummy.parse_response(URI.parse "http://google.com")
    end.should raise_error
  end

  it "#generate_signature should return the encrypted api key, shared secret, and timestamp" do
    Suitcase::Configuration.stub(:hotel_api_key) { "abc" }
    Suitcase::Configuration.stub(:hotel_shared_secret) { "123" }
    Time.stub(:now) { "10" }

    returned = Dummy.generate_signature
    returned.should == Digest::MD5.hexdigest("abc12310")
  end
end
