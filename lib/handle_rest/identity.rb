module HandleRest
  # Handle User Identity
  class Identity
    private_class_method :new

    # @return [Integer]
    attr_reader :index
    # @return [Handle]
    attr_reader :handle

    # Serialize
    #
    # @return [String] in the form "index:prefix/suffix"
    def to_s
      "#{@index}:#{@handle}"
    end

    # Deserialize
    #
    # @param str [String] in the form "index:prefix/suffix"
    # @return [Identity]
    def self.from_s(str)
      m = /^\A([^:\s]+):(\S+)\z$/i.match(str.strip)
      new(m[1].to_i, Handle.from_s(m[2]))
    end

    # Equivalence
    #
    # @param other [Identity]
    # @return [Boolean]
    def ==(other)
      index == other.index && handle == other.handle
    end

    # Three-Way Comparison
    #
    # @param other [Identity]
    # @return [Integer|nil] -1 if less than, 0 if equal to, 1 if greater than, nil if error
    def <=>(other)
      return index <=> other.index unless (index <=> other.index) == 0
      handle <=> other.handle
    end

    # @return [NilIdentity]
    def self.nil
      NilIdentity.send(:new)
    end

    private

    # Initialize
    #
    # @param index [Integer]
    # @param handle [Handle]
    # @return [identity]
    def initialize(index, handle)
      @index = index
      @handle = handle
    end
  end
end
