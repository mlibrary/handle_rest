module HandleRest
  # Handle Public Key Value
  class PublicKeyValue < Value
    # Value Type
    #
    # @return [String] "HS_PUBKEY"
    def type
      "HS_PUBKEY"
    end

    # Deserialize
    #
    # @param format [String] "string"
    # @param value [String] "not implemented yet!"
    # @return [PublicKeyValue]
    # @raise [RuntimeError] if format != 'string'.
    def self.from_h(format, value)
      raise "PublicKeyValue unexpected format '#{format}'" unless /string/.match?(format)
      new(value)
    end
  end
end
