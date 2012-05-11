require "turn"
require "minitest/spec"
require "minitest/autorun"
require "mocha"

require "pry"

$: << File.dirname(__FILE__) + "/../lib"
$: << File.dirname(__FILE__)
require "suitcase"
require "keys"

Turn.config do |config|
  config.format = :pretty
  # config.trace = true
  config.natural = true
end
