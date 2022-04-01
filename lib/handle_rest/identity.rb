module HandleRest
  class Identity
    private_class_method :new

    attr_reader :index
    attr_reader :handle

    # Serialize
    #
    # @return [String]
    def to_s
      "#{@index}:#{@handle}"
    end

    # Deserialize
    #
    # @return [identity]
    def self.from_s(str)
      m = /^\A([^:\s]+):(\S+)\z$/i.match(str.strip)
      new(m[1].to_i, Handle.from_s(m[2]))
    end

    # Equivalence operator
    #
    # @return [Boolean]
    def ==(other)
      index == other.index && handle == other.handle
    end

    def <=>(other)
      index <=> other.index unless (index <=> other.index) == 0
      handle <=> other.handle
    end

    private

    # Initialize a new handle identity
    #
    # @return [identity]
    def initialize(index, handle)
      @index = index
      @handle = handle
    end
  end
end
