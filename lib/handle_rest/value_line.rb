require "json"

module HandleRest
  class ValueLine
    attr_reader :permission_set
    attr_reader :time_to_live

    def initialize(index, value, permission_set: nil, time_to_live: nil)
      self.index = index
      self.value = value
      self.permission_set = permission_set
      self.time_to_live = time_to_live
    end

    def index=(n)
      raise "index must be a positive integer" if !n.is_a?(Integer) || n <= 0
      @index = n
    end

    def value=(v)
      raise "value must be a kind of HandleRest::Value" unless v.is_a?(HandleRest::Value)
      @value = v
    end

    def permission_set=(ps)
      if ps.nil?
        ps = case @value.type
             when "HS_PUBKEY", "HS_SECKEY"
               PermissionSet.from_s("1100")
             else
               PermissionSet.from_s("1110")
        end
      end
      raise "permission set must be a kind of HandleRest::PermissionSet" unless ps.is_a?(HandleRest::PermissionSet)
      @permission_set = ps
    end

    def time_to_live=(seconds)
      seconds = 86400 if seconds.nil?
      raise "time to live must be an integer greater than or equal to zero" if !seconds.is_a?(Integer) || seconds < 0
      @time_to_live = seconds
    end
  end
end
