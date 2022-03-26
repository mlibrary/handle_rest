require "json"

module HandleRest
  # wraps permission set
  class PermissionSet
    attr_accessor :admin_read
    attr_accessor :admin_write
    attr_accessor :public_read
    attr_accessor :public_write

    # Initialize a new permission set
    #
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

    # Serialize a permission set
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

    # Deserialize a permission set
    #
    # @return [PermissionSet]
    def self.from_s(s)
      rv = new
      rv.admin_read = HandleRest.character_to_boolean(s.slice!(0))
      rv.admin_write = HandleRest.character_to_boolean(s.slice!(0))
      rv.public_read = HandleRest.character_to_boolean(s.slice!(0))
      rv.public_write = HandleRest.character_to_boolean(s.slice!(0))
      rv
    end

    # Equivalence operator
    #
    # @return [Boolean]
    def ==(other)
      admin_read == other.admin_read &&
        admin_write == other.admin_write &&
        public_read == other.public_read &&
        public_write == other.public_write
    end
  end
end
