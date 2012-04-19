# Suitcase::Configuration.hotel_api_key = "your_api_key_here"
# Suitcase::Configuration.hotel_cid = "your_cid_here"
# Suitcase::Configuration.hotel_shared_secret = "your_shared_secret_here"
# Suitcase::Configuration.use_signature_auth = true

# Or configure with a block:

Suitcase.configure do |config|
  config.hotel_api_key = "your_api_key_here"
  config.hotel_cid = "your_cid_here"
  config.hotel_shared_secret = "your_shared_secret_here"
  # config.use_signature_auth = true
end
