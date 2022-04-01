module HandleRest
  class UrlValue < Value
    def type
      "URL"
    end

    def self.from_h(format, value)
      raise "UrlValue unexpected format #{format}" unless /string/i.match?(format)
      new(value)
    end
  end
end
