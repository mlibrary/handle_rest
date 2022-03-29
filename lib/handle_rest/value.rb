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
  end
end
