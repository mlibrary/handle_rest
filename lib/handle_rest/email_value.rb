module HandleRest
  # Handle Email Value
  class EmailValue < Value
    # Initialize
    #
    # @param value [String] scheme/protocol://host name[:port number] [/path][/query_string][/#fragment]
    # @return [EmailValue]
    # @raise [RuntimeError] if invalid email form
    def initialize(value)
      super
      raise URI::InvalidComponentError, "unrecognised opaque part for mailtoURL: ?subject=email" if value.nil?
      URI::MailTo.build([@value, "subject=email"])
    end

    # Value Type
    #
    # @return [String] "EMAIL"
    def type
      "EMAIL"
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
    # @return [EmailValue]
    # @raise [RuntimeError] if invalid email form
    def self.from_s(value)
      new(value)
    end

    # Deserialize
    #
    # @param format [String] "string"
    # @param value [String] e.g. "wolverine@umich.edu"
    # @return [EmailValue]
    # @raise [RuntimeError] if format != 'string'.
    def self.from_h(format, value)
      raise "EmailValue unexpected format '#{format}'" unless /string/.match?(format)
      new(value)
    end
  end
end
