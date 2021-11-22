module Verify
    def valid_phone_number?(country_code, phone_number)
      response = Authy::PhoneVerification.start(country_code: country_code, phone_number: phone_number)
      response.success?
    end
  end
  