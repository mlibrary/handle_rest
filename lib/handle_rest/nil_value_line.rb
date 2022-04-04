require "json"

module HandleRest
  # Handle Nil Value Line
  class NilValueLine < ValueLine
    # @return [0]
    attr_reader :index
    # @return [NilValue]
    attr_reader :value
    # @return [PermissionSet.from_s("0000")]
    attr_reader :permissions
    # @return [86400]
    attr_reader :time_to_live

    # Initialize
    #
    # @param index [Integer]
    # @param value [Value]
    # @param permissions [PermissionSet]
    # @param time_to_live [Integer]
    def initialize(index = 0, value = nil, permissions: nil, time_to_live: nil)
      self.index = index
      self.value = value
      self.permissions = permissions
      self.time_to_live = time_to_live
    end

    # nil?
    #
    # @return true
    def nil?
      true
    end

    # @param _n [Integer]
    # @return [Integer] 0
    def index=(_n)
      @index = 0
    end

    # @param _v [Value]
    # @return [NilValue]
    def value=(_v)
      @value = Value.nil
    end

    # @param _ps [PermissionSet|nil]
    # @return [PermissionSet.from_s("0000")]
    def permissions=(_ps)
      @permissions = PermissionSet.from_s("0000")
    end

    # @param _seconds [Integer|nil]
    # @return [Integer]
    def time_to_live=(_seconds)
      @time_to_live = 86400
    end

    # Serialize to hash
    #
    # @param options [Hash]
    # @return [Hash] !{index: [Integer], type: [String], data: [Blob], ttl: [Integer], permissions: [String]}
    def as_json(options = {})
      {
        index: 0,
        type: "NIL",
        data: Value.nil,
        ttl: 86400,
        permissions: "0000"
      }
    end

    # Deserialize
    #
    # @param _str [String]
    # @return [NilValueLine]
    def self.from_s(_str)
      new
    end

    # Deserialize from hash (see #as_json)
    #
    # @param _value [Hash]
    # @return [NilValueLine]
    def self.from_h(_value)
      new
    end
  end
end
