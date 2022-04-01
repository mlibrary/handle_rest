module HandleRest
  class Identifier
    private_class_method :new

    attr_reader :prefix
    attr_reader :suffix

    # Serialize
    #
    # @return [String]
    def to_s
      "#{@prefix}/#{@suffix}"
    end

    # Deserialize
    #
    # @return [Identifier]
    def self.from_s(s)
      m = /^\A([^\/\s]+)\/(\S+)\z$/i.match(s.strip)
      prefix = m[1]
      suffix = m[2]
      Identifier.send(:new, prefix, suffix)
    end

    # Equivalence operator
    #
    # @return [Boolean]
    def ==(other)
      prefix == other.prefix && suffix == other.suffix
    end

    private

    # Initialize a new handle identifier
    #
    # @return [Identifier]
    def initialize(prefix, suffix)
      @prefix = prefix.upcase
      @suffix = suffix.upcase
    end
  end
end
