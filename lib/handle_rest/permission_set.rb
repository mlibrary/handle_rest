module HandleRest
  # Handle Permission Set
  class PermissionSet
    # @return [Boolean]
    attr_accessor :admin_read
    # @return [Boolean]
    attr_accessor :admin_write
    # @return [Boolean]
    attr_accessor :public_read
    # @return [Boolean]
    attr_accessor :public_write

    # Initialize
    #
    # @param admin_read: [Boolean]
    # @param admin_write: [Boolean]
    # @param public_read: [Boolean]
    # @param public_write: [Boolean]
    # @return [PermissionSet]
    def initialize(
      admin_read: true,
      admin_write: true,
      public_read: true,
      public_write: true
    )
      @admin_read = admin_read
      @admin_write = admin_write
      @public_read = public_read
      @public_write = public_write
    end

    # Serialize
    #
    # Twelve character string { '0' | '1' } with the following order:
    #   admin read, admin write, public read, public write
    #
    # @return [String]
    def to_s
      rv = ""
      rv += HandleRest.boolean_to_character(admin_read)
      rv += HandleRest.boolean_to_character(admin_write)
      rv += HandleRest.boolean_to_character(public_read)
      rv += HandleRest.boolean_to_character(public_write)
      rv
    end

    # Deserialize
    #
    # Twelve character string { '0' | '1' } with the following order:
    #   admin read, admin write, public read, public write
    #
    # @param str [String] permissions e.g. "1110"
    # @return [PermissionSet]
    def self.from_s(str)
      s = str.dup
      rv = new
      rv.admin_read = HandleRest.character_to_boolean(s.slice!(0))
      rv.admin_write = HandleRest.character_to_boolean(s.slice!(0))
      rv.public_read = HandleRest.character_to_boolean(s.slice!(0))
      rv.public_write = HandleRest.character_to_boolean(s.slice!(0))
      rv
    end

    # Equivalence
    #
    # @param other [PermissionSet]
    # @return [Boolean]
    def ==(other)
      admin_read == other.admin_read &&
        admin_write == other.admin_write &&
        public_read == other.public_read &&
        public_write == other.public_write
    end
  end
end
