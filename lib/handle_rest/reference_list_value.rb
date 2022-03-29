require "json"

module HandleRest
  class ReferenceListValue < Value
    def type
      "VLIST"
    end
  end
end
