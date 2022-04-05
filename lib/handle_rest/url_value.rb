module HandleRest
  # Handle URL Value
  class UrlValue < Value
    # Initialize
    #
    # @param value [String] scheme/protocol://host name[:port number] [/path][/query_string][/#fragment]
    # @return [UrlValue]
    # @raise [RuntimeError] if invalid url form
    def initialize(value)
      super
      URI.parse(@value)
    end

    # Value Type
    #
    # @return [String] "URL"
    def type
      "URL"
    end

    # Serialize
    #
    # @return [String] scheme/protocol://host name[:port number] [/path][/query_string][/#fragment]
    def to_s
      @value
    end

    # Deserialize
    #
    # @param value [String] scheme/protocol://host name[:port number] [/path][/query_string][/#fragment]
    # @return [UrlValue]
    # @raise [RuntimeError] if invalid url form
    def self.from_s(value)
      new(value)
    end

    # Deserialize
    #
    # @param format [String] "string"
    # @param value [String] in the form: `scheme/protocol://host name[:port number] [/path][/query_string][/#fragment]`
    # @return [UrlValue]
    # @raise [RuntimeError] if format != 'string' or value invalid url form
    def self.from_h(format, value)
      raise "UrlValue unexpected format '#{format}'" unless /string/.match?(format)
      from_s(value)
    end
  end
end
