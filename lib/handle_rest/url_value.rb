require "json"

module HandleRest
  class UrlValue < Value
    def type
      "URL"
    end
  end
end
