require "json"

module HandleRest
  class EmailValue < Value
    def type
      "EMAIL"
    end

    def self.from_h(format, value)
      raise "EmailValue unexpected format #{format}" unless /string/i.match?(format)
      new(value)
    end
  end
end
