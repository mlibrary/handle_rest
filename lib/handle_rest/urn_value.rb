module HandleRest
  # Handle URN Value
  class UrnValue < Value
    # Value Type
    #
    # @return [String] "URN"
    def type
      "URN"
    end

    # Deserialize
    #
    # @param format [String] "string"
    # @param value [String] urn:<nid>:<nss></nss></nid>
    # @return [UrnValue]
    # @raise [RuntimeError] if format != 'string'.
    def self.from_h(format, value)
      raise "UrnValue unexpected format '#{format}'" unless /string/.match?(format)
      new(value)
    end
  end
end
