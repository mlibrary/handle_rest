require "json"

module HandleRest
  class SecretKeyValue < Value
    def type
      "HS_SECKEY"
    end

    def self.from_h(format, value)
      raise "SecretKeyValue unexpected format #{format}" unless /string/i.match?(format)
      new(value)
    end
  end
end
