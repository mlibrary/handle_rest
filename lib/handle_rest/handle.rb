module HandleRest
  # Handle
  class Handle
    private_class_method :new

    # @return [String]
    attr_reader :prefix
    # @return [String]
    attr_reader :suffix

    # Serialize
    #
    # @return [String] e.g. "prefix/suffix"
    def to_s
      "#{@prefix}/#{@suffix}"
    end

    # Deserialize
    #
    # @param str [String] e.g. "prefix/suffix"
    # @return [Handle]
    def self.from_s(str)
      m = /^\A([^\/\s]+)\/(\S+)\z$/i.match(str&.strip)
      raise "Handle string '#{str&.strip}' invalid." unless m && m[1] && m[2]
      prefix = m[1]
      suffix = m[2]
      Handle.send(:new, prefix, suffix)
    end

    # Equivalence
    #
    # @param other [Handle]
    # @return [Boolean]
    def ==(other)
      prefix == other.prefix && suffix == other.suffix
    end

    # Three-Way Comparison
    #
    # @param other [Handle]
    # @return [Integer|nil] -1 if less than, 0 if equal to, 1 if greater than, nil if error
    def <=>(other)
      return prefix <=> other.prefix unless (prefix <=> other.prefix) == 0
      suffix <=> other.suffix
    end

    # @return [NilHandle]
    def self.nil
      NilHandle.from_s
    end

    private

    # Initialize
    #
    # @param prefix [String]
    # @param suffix [String]
    # @return [Handle]
    def initialize(prefix, suffix)
      @prefix = prefix.upcase
      @suffix = suffix.upcase
    end
  end
end
