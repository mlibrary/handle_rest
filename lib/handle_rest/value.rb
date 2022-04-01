require "json"

module HandleRest
  class Value
    attr_accessor :value

    def initialize(value)
      @value = value
    end

    def type
      raise "this method should be overridden and return value type"
    end

    def ==(other)
      type == other.type && value == other.value
    end

    def as_json(options = {})
      {
        format: "string",
        value: @value
      }
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end

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
      else
        raise "Value unexpected { type: #{type}, data: #{data} }"
      end
    end
  end
end
