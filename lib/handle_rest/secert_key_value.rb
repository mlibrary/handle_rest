require "json"

module HandleRest
  # Handle Secret Key Value
  class SecretKeyValue < Value
    # Value Type
    #
    # @return [String] "HS_SECKEY"
    def type
      "HS_SECKEY"
    end

    # Deserialize
    #
    # @param format [String] "string"
    # @param value [String] "password"
    # @return [SecretKeyValue]
    # @raise [RuntimeError] if format != 'string'.
    def self.from_h(format, value)
      raise "SecretKeyValue unexpected format '#{format}'" unless /string/.match?(format)
      new(value)
    end
  end
end
