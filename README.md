Suitcase
========

Suitcase is a Ruby library that utilizes the EAN (Expedia.com) API for locating available hotels, rental cars, and flights.

Installation
------------

Add the following line to your Gemfile:

`gem 'suitcase', :git => "http://github.com/thoughtfusion/suitcase.git"` then run `bundle install`. Or install the gem: `gem install suitcase`.


Usage
-----

First, include the module in your code:

      include Suitcase

Find nearby hotels:

      Hotel::API_KEY = "your_api_key_here"
      hotel = Hotel.find(:location => 'Boston, MA', :results => 10) # Returns 10 closest hotels to Boston, MA
      room = hotel.rooms(arrival: "2/19/2012", departure: "2/26/2012", rooms: [{ children: 1, ages: [8] }, { children: 1, ages: [12] }] # Check the availability of two rooms at that hotel with 1 child in each room of ages 8 and 9
      room.reserve!(info) # Not yet implemented
Contributing
------------
Please submit any useful pull requests through GitHub. If you find any bugs, please report them with the issue tracker! Thanks.
