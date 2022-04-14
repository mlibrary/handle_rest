require "json"

module HandleRest
  # Handle Value Line
  class ValueLine
    # @return [Integer]
    attr_reader :index
    # @return [Value]
    attr_reader :value
    # @return [PermissionSet]
    attr_reader :permissions
    # @return [Integer]
    attr_reader :time_to_live

    # Initialize
    #
    # @param index [Integer]
    # @param value [Value]
    # @param permissions [PermissionSet]
    # @param time_to_live [Integer]
    def initialize(index, value, permissions: nil, time_to_live: nil)
      self.index = index
      self.value = value
      self.permissions = permissions
      self.time_to_live = time_to_live
    end

    # @param n [Integer]
    # @return [Integer]
    def index=(n)
      raise "index must be a positive integer" if !n.is_a?(Integer) || n <= 0
      @index = n
    end

    # @param v [Value]
    # @return [Value]
    def value=(v)
      raise "value must be a kind of HandleRest::Value" unless v.is_a?(HandleRest::Value)
      @value = v
    end

    # @param ps [PermissionSet|nil]
    # @return [PermissionSet]
    def permissions=(ps)
      if ps.nil?
        ps = case @value.type
        when "HS_PUBKEY", "HS_SECKEY"
          PermissionSet.from_s("1100")
        else
          PermissionSet.from_s("1110")
        end
      end
      raise "permission set must be a kind of HandleRest::PermissionSet" unless ps.is_a?(HandleRest::PermissionSet)
      @permissions = ps
    end

    # @param seconds [Integer|nil]
    # @return [Integer]
    def time_to_live=(seconds)
      seconds = 86400 if seconds.nil?
      raise "time to live must be an integer greater than or equal to zero" if !seconds.is_a?(Integer) || seconds < 0
      @time_to_live = seconds
    end

    # Equivalence
    #
    # @param other [ValueLine]
    # @return [Boolean]
    def ==(other)
      index == other.index &&
        value == other.value
      # permissions == other.permissions &&
      # time_to_live == other.time_to_live
    end

    # Serialize to hash
    #
    # @param options [Hash]
    # @return [Hash] !{index: [Integer], type: [String], data: [Blob], ttl: [Integer], permissions: [String]}
    def as_json(options = {})
      {
        index: @index,
        type: @value.type,
        data: @value,
        ttl: @time_to_live,
        permissions: permissions.to_s
      }
    end

    # Serialize to json
    #
    # @param options [Splat]
    # @return [Hash]
    def to_json(*options)
      as_json(*options).to_json(*options)
    end

    # Deserialize from hash (see #as_json)
    #
    # @param value [Hash] !{index: [Integer], type: [String], data: [Blob], permissions: [String], ttl: [Integer]}
    # @return [ValueLine]
    def self.from_h(value)
      permissions = nil
      permissions = HandleRest::PermissionSet.from_s(value["permissions"]) unless value["permissions"].nil?
      new(
        value["index"].to_i,
        HandleRest::Value.from_h(value["type"], value["data"]),
        permissions: permissions,
        time_to_live: value["ttl"]
      )
    end

    # @return [NilValueLine]
    def self.nil
      NilValueLine.new
    end
  end
end
