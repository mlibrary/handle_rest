require "json"

module HandleRest
  # Handle Value Base Class
  class Value
    # @return [Value]
    attr_accessor :value

    # Initialize
    #
    # @param value [blob]
    # @return [Value]
    def initialize(value)
      @value = value
    end

    # Value Type
    #
    # @raise [RuntimeError] if instance of virtual base class
    def type
      raise "this method should be overridden and return value type"
    end

    # Equivalence
    #
    # @param other [Value]
    # @return [Boolean]
    def ==(other)
      type == other.type && value == other.value
    end

    # Serialize to hash
    #
    # @param options [Hash]
    # @return [Hash] !{format: "string", value: [String]}
    def as_json(options = {})
      {
        format: "string",
        value: @value
      }
    end

    # Serialize to json
    #
    # @param options [Hash]
    # @return [Hash]
    def to_json(*options)
      as_json(*options).to_json(*options)
    end

    # Deserialize from hash (see #as_json)
    #
    # @param type [String] "HS_ADMIN"|"HS_PUBKEY"|"HS_SECKEY"|"HS_VLIST"|"EMAIL"|"URL"|"URN"
    # @param data [HASH] !{format: [String], value: [Hash]}
    # @return [AdminValue]
    # @raise [RuntimeError] if type unknown.
    def self.from_h(type, data)
      case type
      when "HS_ADMIN"
        AdminValue.from_h(data["format"], data["value"])
      when "HS_PUBKEY"
        PublicKeyValue.from_h(data["format"], data["value"])
      when "HS_SECKEY"
        SecretKeyValue.from_h(data["format"], data["value"])
      when "HS_VLIST"
        ReferenceListValue.from_h(data["format"], data["value"])
      when "EMAIL"
        EmailValue.from_h(data["format"], data["value"])
      when "URL"
        UrlValue.from_h(data["format"], data["value"])
      when "URN"
        UrnValue.from_h(data["format"], data["value"])
      when "NIL"
        NilValue.from_h(data["format"], data["value"])
      else
        raise "Value unexpected { type: #{type}, data: #{data} }"
      end
    end

    # @return [NilValueLine]
    def self.nil
      NilValue.new
    end
  end
end
