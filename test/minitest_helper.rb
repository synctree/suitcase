require "minitest/spec"
require "minitest/autorun"

require "pry"

$: << File.dirname(__FILE__) + "/../lib"
$: << File.dirname(__FILE__)
require "suitcase"
require "keys"