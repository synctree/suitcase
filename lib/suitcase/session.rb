module Suitcase
  Session = Struct.new(:id, :user_agent, :ip_address, :locale, :currency_code)
end
