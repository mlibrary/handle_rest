require "json"

module HandleRest
  class EmailValue < Value
    def type
      "EMAIL"
    end
  end
end
