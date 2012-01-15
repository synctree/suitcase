require 'spec_helper'

describe Suitcase::Session do
  it { should respond_to :id }
  it { should respond_to :ip_address }
  it { should respond_to :user_agent }
  it { should respond_to :locale }
  it { should respond_to :currency_code }

  it "should be able to be passed in to a find query" do
    s = Suitcase::Session.new
    Suitcase::Hotel.find(id: 123904, session: s)
    s.id.should_not be_nil
  end
end
