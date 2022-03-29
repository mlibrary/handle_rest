require "json"

module HandleRest
  class SecretKeyValue < Value
    def type
      "HS_SECKEY"
    end
  end
end
