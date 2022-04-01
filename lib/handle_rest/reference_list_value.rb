require "json"

module HandleRest
  class ReferenceListValue < Value
    def initialize(value)
      @value = value
    end

    def type
      "HS_VLIST"
    end

    def ==(other)
      value.sort == other.value.sort
    end

    def as_json(options = {})
      {
        format: "vlist",
        value: @value.map { |v| {index: v.index.to_i, handle: v.handle.to_s} }
      }
    end

    def self.from_h(format, value)
      case format
      when "vlist"
        new(value.map { |v| Identity.from_s("#{v["index"].to_i}:#{v["handle"]}") })
      when "base64"
        new(Base64.decode64(value))
      else
        raise "ReferenceListValue unexpected format #{format}"
      end
    end
  end
end
