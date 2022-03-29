require "json"

module HandleRest
  class PublicKeyValue < Value
    def type
      "HS_PUBKEY"
    end
  end
end
