module HandleRest
  # Handle Nil Value
  class NilValue < Value
    # Initialize
    #
    # @param _value [Object|nil]
    # @return [NilValue]
    def initialize(_value = nil)
      @value = ""
    end

    # nil?
    #
    # @return true
    def nil?
      true
    end

    # Value Type
    #
    # @return [String] 'NIL'
    def type
      "NIL"
    end

    # Serialize
    #
    # @return [String] ''
    def to_s
      @value
    end

    # Deserialize
    #
    # @param _value [Object|nil]
    # @return [NilValue]
    def self.from_s(_value = nil)
      new
    end

    # Deserialize
    #
    # @param format [String] "string"
    # @param value [Object|nil]
    # @return [NilValue]
    # @raise [RuntimeError] if format != 'string' or value invalid url form
    def self.from_h(format, value)
      raise "NilValue unexpected format '#{format}'" unless /string/.match?(format)
      from_s(value)
    end
  end
end
