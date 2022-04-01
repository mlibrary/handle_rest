require "json"

module HandleRest
  class UrnValue < Value
    def type
      "URN"
    end

    def self.from_h(format, value)
      raise "UrnValue unexpected format #{format}" unless /string/i.match?(format)
      new(value)
    end
  end
end
