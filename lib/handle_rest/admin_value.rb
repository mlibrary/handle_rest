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

    def as_json(options = {})
      {
        format: "admin",
        value: {
          index: index,
          permissions: permission_set.to_s,
          handle: identifier.to_s
        }
      }
    end

    def self.from_s(str)
      m = /^\A([^:\s]+):([01]{12}):(\S+)\z$/i.match(str.strip)
      new(m[1].to_i, HandleRest::AdminPermissionSet.from_s(m[2]), HandleRest::Identifier.from_s(m[3]))
    end

    def self.from_h(format, value)
      case format
      when "string"
        from_s(value)
      when "admin"
        new(
          value["index"].to_i,
          HandleRest::AdminPermissionSet.from_s(value["permissions"]),
          HandleRest::Identifier.from_s(value["handle"])
        )
      else
        raise "AdminValue unexpected format #{format}"
      end
    end
  end
end
