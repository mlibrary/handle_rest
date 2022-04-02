require "json"

module HandleRest
  # Handle Admin Value
  class AdminValue < Value
    # @return [Integer]
    attr_accessor :index
    # @return [AdminPermissionSet]
    attr_accessor :permissions
    # @return [Handle]
    attr_accessor :handle

    # Initialize
    #
    # @param index [Integer]
    # @param permissions [AdminPermissionSet]
    # @param handle [Handle]
    # @return [AdminValue]
    def initialize(index, permissions, handle)
      @index = index
      @permissions = permissions
      @handle = handle
    end

    # Value Type
    #
    # @return [String] "HS_ADMIN"
    def type
      "HS_ADMIN"
    end

    # Serialize to hash
    #
    # @param options [Hash]
    # @return [Hash] { format: "admin", value: { index: [Integer], permissions: [String], handle: [String] }}
    def as_json(options = {})
      {
        format: "admin",
        value: {
          index: index,
          permissions: permissions.to_s,
          handle: handle.to_s
        }
      }
    end

    # Deserialize from string
    #
    # @param str [String] of the form "index:permissions:handle" e.g. "300:111111111111:0.NA/PREFIX"
    # @return [AdminValue]
    def self.from_s(str)
      m = /^\A([^:\s]+):([01]{12}):(\S+)\z$/i.match(str.strip)
      new(m[1].to_i, HandleRest::AdminPermissionSet.from_s(m[2]), HandleRest::Handle.from_s(m[3]))
    end

    # Deserialize from hash (see #as_json)
    #
    # @param format [String] "admin"
    # @param value [{ index: [Integer], permissions: [String], handle: [String]}]
    # @return [AdminValue]
    # @raise [RuntimeError] if format != 'admin'.
    def self.from_h(format, value)
      raise "AdminValue unexpected format '#{format}'" unless /admin/.match?(format)
      new(
        value["index"].to_i,
        HandleRest::AdminPermissionSet.from_s(value["permissions"]),
        HandleRest::Handle.from_s(value["handle"])
      )
    end
  end
end
