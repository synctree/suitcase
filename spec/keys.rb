# Suitcase::Configuration.hotel_api_key = "your_api_key_here"
# Suitcase::Configuration.hotel_cid = "your_cid_here"

# Or configure with a block:

Suitcase.configure do |config|
  config.hotel_api_key = "your_api_key_here"
  config.hotel_cid = "your_cid_here"
end
