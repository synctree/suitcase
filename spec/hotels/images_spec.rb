require 'spec_helper'

describe Suitcase::Image do
  before :all do
    @image = Suitcase::Hotel.find(id: 123904).images.first
  end

  subject { @image }

  it { should respond_to :url }
  it { should respond_to :id }
  it { should respond_to :caption }
  it { should respond_to :height }
  it { should respond_to :width }
  it { should respond_to :thumbnail_url }
  it { should respond_to :name } 

  it "#url should return a valid URL" do
    lambda do
      URI.parse @image.url
    end.should_not raise_error
  end
end
