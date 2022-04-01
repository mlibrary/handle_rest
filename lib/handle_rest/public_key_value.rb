require "json"

module HandleRest
  class PublicKeyValue < Value
    def type
      "HS_PUBKEY"
    end

    def self.from_h(format, value)
      raise "PublicKeyValue unexpected format #{format}" unless /string/i.match?(format)
      new(value)
    end
  end
end
