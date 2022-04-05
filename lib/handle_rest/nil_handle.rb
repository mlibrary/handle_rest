module HandleRest
  # Nil Handle
  class NilHandle < Handle
    # @return [Boolean] true
    def nil?
      true
    end

    # Deserialize
    #
    # @param _str [Object|nil]
    # @return [NilHandle]
    def self.from_s(_str = nil)
      new
    end

    private

    # Initialize
    #
    # @param _prefix [Object|nil]
    # @param _suffix [Object|nil]
    # @return [NilHandle]
    def initialize(_prefix = nil, _suffix = nil)
      @prefix = ""
      @suffix = ""
    end
  end
end
