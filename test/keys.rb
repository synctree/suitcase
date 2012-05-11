# Suitcase::Configuration.hotel_api_key = "your_api_key_here"
# Suitcase::Configuration.hotel_cid = "your_cid_here"
# Suitcase::Configuration.hotel_shared_secret = "your_shared_secret_here"
# Suitcase::Configuration.use_signature_auth = true

# Or configure with a block:

Suitcase.configure do |config|
  config.hotel_api_key = "t3d74e8t58k2nh55gyph3cje"
  config.hotel_cid = "55505"
  # config.hotel_shared_secret = "none"
  # config.use_signature_auth = false
end

module Keys
  SUITCASE_PAYMENT_OPTION = Suitcase::PaymentOption.find(currency_code: "USD")[0]
  CREDIT_CARD_NUMBER_TESTING = "1234123412341234"
  CREDIT_CARD_CVV_TESTING = "123"
  CREDIT_CARD_EXPIRATION_DATE_TESTING = "3/14"

  VALID_RESERVATION_INFO = {
    email: "testemail@gmail.com",
    first_name: "Test",
    last_name: "User",
    home_phone: "1231231234",
    payment_option: SUITCASE_PAYMENT_OPTION,
    credit_card_number: CREDIT_CARD_NUMBER_TESTING, 
    credit_card_verification_code: "123",
    credit_card_expiration_date: CREDIT_CARD_EXPIRATION_DATE_TESTING,
    address1: "1 Some Place",
    city: "Boston",
    province: "MA",
    country: "US",
    postal_code: "01234",
  }
end
