class FakeResponse
  attr_reader :code, :body

  def initialize(options = {})
    options.each { |k, v| instance_variable_set("@#{k}", v) }
  end
end
