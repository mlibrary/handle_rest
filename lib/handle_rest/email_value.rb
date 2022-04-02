module HandleRest
  # Handle Email Value
  class EmailValue < Value
    # Value Type
    #
    # @return [String] "EMAIL"
    def type
      "EMAIL"
    end

    # Deserialize
    #
    # @param format [String] "string"
    # @param value [String] "wolverine@umich.edu"
    # @return [EmailValue]
    # @raise [RuntimeError] if format != 'string'.
    def self.from_h(format, value)
      raise "EmailValue unexpected format '#{format}'" unless /string/.match?(format)
      new(value)
    end
  end
end
