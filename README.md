Suitcase
========

Suitcase is a Ruby library that utilizes the EAN (Expedia.com) API for locating available hotels, rental cars, and flights.

Installation
------------

Add the following line to your Gemfile:
`gem 'suitcase', :git => "http://github.com/thoughtfusion/suitcase.git"`
Then run
`bundle install`

Usage
-----
Find nearby hotels:
Hotel.near('Boston, MA', 10) # Returns 10 closest hotels to Boston, MA
Hotel.near('Metropoliton Museum of Art') # Returns 50 closest hotels to the MFA

Find available airline flights:
Flights.available('June 23 2012', :from => "Boston, MA, USA", :to => "Dublin, Ireland") # Return all flights flying from Boston to Dublin on June 23, 2012

Contributing
------------
Please submit any useful pull requests through GitHub. If you find any bugs, please report them! Thanks.
