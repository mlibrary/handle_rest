require "json"

module HandleRest
  # Handle Reference List Value
  class ReferenceListValue < Value
    # Initialize
    #
    # @param value [Identity]
    # @return [ReferenceListValue]
    def initialize(value)
      @value = value
    end

    # Value Type
    #
    # @return [String] "HS_VLIST"
    def type
      "HS_VLIST"
    end

    # Equivalence
    #
    # @param other [ReferenceListValue]
    # @return [Boolean]
    def ==(other)
      value.sort == other.value.sort
    end

    # Serialize to hash
    #
    # @param options [Hash]
    # @return [[Hash]] [{index: [Integer], handle: [String]}]
    def as_json(options = {})
      {
        format: "vlist",
        value: @value.map { |v| {index: v.index.to_i, handle: v.handle.to_s} }
      }
    end

    # Deserialize from hash (see #as_json)
    #
    # @param format [String] "vlist"
    # @param value [[Hash]] [{index: [Integer], handle: [String]}]
    # @return [ReferenceListValue]
    # @raise [RuntimeError] if format != 'vlist'.
    def self.from_h(format, value)
      raise "ReferenceListValue unexpected format '#{format}'" unless /vlist/.match?(format)
      new(value.map { |v| Identity.from_s("#{v["index"].to_i}:#{v["handle"]}") })
    end
  end
end
