require "json"

module HandleRest
  class AdminValue < Value
    attr_accessor :index
    attr_accessor :permission_set
    attr_accessor :identifier

    def initialize(index, permission_set, identifier)
      @index = index
      @permission_set = permission_set
      @identifier = identifier
    end

    def type
      "HS_ADMIN"
    end
  end
end
