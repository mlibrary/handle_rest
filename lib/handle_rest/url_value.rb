module HandleRest
  # Handle URL Value
  class UrlValue < Value
    # Value Type
    #
    # @return [String] "URL"
    def type
      "URL"
    end

    # Deserialize
    #
    # @param format [String] "string"
    # @param value [String] scheme/protocol://host name[:port number] [/path][/query_string][/#fragment]
    # @return [UrlValue]
    # @raise [RuntimeError] if format != 'string'.
    def self.from_h(format, value)
      raise "UrlValue unexpected format '#{format}'" unless /string/.match?(format)
      new(value)
    end
  end
end
