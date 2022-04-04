module HandleRest
  # Handle User Nil Identity
  class NilIdentity < Identity
    # @return [Boolean] true
    def nil?
      true
    end

    # Deserialize
    #
    # @param _str [Object|nil]
    # @return [NilIdentity]
    def self.from_s(_str = nil)
      new
    end

    private

    # Initialize
    #
    # @param _index [Integer]
    # @param _handle [Handle]
    # @return [identity]
    def initialize(_index = nil, _handle = nil)
      @index = 0
      @handle = Handle.nil
    end
  end
end
