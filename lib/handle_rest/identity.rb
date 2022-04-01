module HandleRest
  class Identity
    private_class_method :new

    attr_reader :index
    attr_reader :identifier

    # Serialize
    #
    # @return [String]
    def to_s
      "#{@index}:#{@identifier}"
    end

    # Deserialize
    #
    # @return [identity]
    def self.from_s(str)
      m = /^\A([^:\s]+):(\S+)\z$/i.match(str.strip)
      new(m[1].to_i, Identifier.from_s(m[2]))
    end

    # Equivalence operator
    #
    # @return [Boolean]
    def ==(other)
      index == other.index && identifier == other.identifier
    end

    private

    # Initialize a new handle identity
    #
    # @return [identity]
    def initialize(index, identifier)
      @index = index
      @identifier = identifier
    end
  end
end
