require 'suitcase'

Given /^I have an API key$/ do
  Suitcase::Hotel::API_KEY = "3kx2vhr7sjrgmsyddb2cg47j"
end

When /^I submit a request to find (\d+) hotels in (.+)$/ do |results, location|
  @hotels = Suitcase::Hotel.find(:near => location, :results => results.to_i)
end

Then /^I want to receive (\d+) hotels with their respective information$/ do |results|
  @hotels.count.should eq(results.to_i)
end

When /^I submit a request to find more information about a hotel with id (\d+)$/ do |id|
  @hotel = Suitcase::Hotel.find_by_id(id)
end

Then /^I want to receive more information about that hotel$/ do
  @hotel.should_not be_nil
end
