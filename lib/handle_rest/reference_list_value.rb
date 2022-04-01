require "json"

module HandleRest
  class ReferenceListValue < Value
    def type
      "VLIST"
    end

    def self.from_h(format, value)
      raise "ReferenceListValue unexpected format #{format}" unless /string/i.match?(format)
      new(value)
    end
  end
end
