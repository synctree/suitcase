load 'air.rb'

include Suitcase
Suitcase::Flight::API_KEY = "hidden"
Suitcase::Flight.available(:from => "BOS", :to => "LHR", :departs => "1/7/2012 10:00 AM", :arrives => "1/7/2012 1:00 AM", :adults => 1)
