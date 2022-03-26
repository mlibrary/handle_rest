require "json"

module HandleRest
  class UrnValue < Value
    def type
      "URN"
    end
  end
end
