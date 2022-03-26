require "json"

module HandleRest
  # wraps admin permission set
  class AdminPermissionSet
    attr_accessor :add_handle
    attr_accessor :delete_handle
    attr_accessor :add_naming_authority
    attr_accessor :delete_naming_authority
    attr_accessor :modify_values
    attr_accessor :remove_values
    attr_accessor :add_values
    attr_accessor :read_values
    attr_accessor :modify_administrator
    attr_accessor :remove_administrator
    attr_accessor :add_administrator
    attr_accessor :list_handles

    # Initialize a new permission set
    #
    # @return [AdminPermissionSet]
    def initialize(
      add_handle: true,
      delete_handle: true,
      add_naming_authority: true,
      delete_naming_authority: true,
      modify_values: true,
      remove_values: true,
      add_values: true,
      read_values: true,
      modify_administrator: true,
      remove_administrator: true,
      add_administrator: true,
      list_handles: true
    )
      @add_handle = add_handle
      @delete_handle = delete_handle
      @add_naming_authority = add_naming_authority
      @delete_naming_authority = delete_naming_authority
      @modify_values = modify_values
      @remove_values = remove_values
      @add_values = add_values
      @read_values = read_values
      @modify_administrator = modify_administrator
      @remove_administrator = remove_administrator
      @add_administrator = add_administrator
      @list_handles = list_handles
    end

    # Serialize a permission set
    #
    # @return [String]
    def to_s
      rv = ""
      rv += HandleRest.boolean_to_character(add_handle)
      rv += HandleRest.boolean_to_character(delete_handle)
      rv += HandleRest.boolean_to_character(add_naming_authority)
      rv += HandleRest.boolean_to_character(delete_naming_authority)
      rv += HandleRest.boolean_to_character(modify_values)
      rv += HandleRest.boolean_to_character(remove_values)
      rv += HandleRest.boolean_to_character(add_values)
      rv += HandleRest.boolean_to_character(read_values)
      rv += HandleRest.boolean_to_character(modify_administrator)
      rv += HandleRest.boolean_to_character(remove_administrator)
      rv += HandleRest.boolean_to_character(add_administrator)
      rv += HandleRest.boolean_to_character(list_handles)
      rv
    end

    # Deserialize a permission set
    #
    # @return [AdminPermissionSet]
    def self.from_s(s)
      rv = new
      rv.add_handle = HandleRest.character_to_boolean(s.slice!(0))
      rv.delete_handle = HandleRest.character_to_boolean(s.slice!(0))
      rv.add_naming_authority = HandleRest.character_to_boolean(s.slice!(0))
      rv.delete_naming_authority = HandleRest.character_to_boolean(s.slice!(0))
      rv.modify_values = HandleRest.character_to_boolean(s.slice!(0))
      rv.remove_values = HandleRest.character_to_boolean(s.slice!(0))
      rv.add_values = HandleRest.character_to_boolean(s.slice!(0))
      rv.read_values = HandleRest.character_to_boolean(s.slice!(0))
      rv.modify_administrator = HandleRest.character_to_boolean(s.slice!(0))
      rv.remove_administrator = HandleRest.character_to_boolean(s.slice!(0))
      rv.add_administrator = HandleRest.character_to_boolean(s.slice!(0))
      rv.list_handles = HandleRest.character_to_boolean(s.slice!(0))
      rv
    end

    # Equivalence operator
    #
    # @return [Boolean]
    def ==(other)
      add_handle == other.add_handle &&
        delete_handle == other.delete_handle &&
        add_naming_authority == other.add_naming_authority &&
        delete_naming_authority == other.delete_naming_authority &&
        modify_values == other.modify_values &&
        remove_values == other.remove_values &&
        add_values == other.add_values &&
        read_values == other.read_values &&
        modify_administrator == other.modify_administrator &&
        remove_administrator == other.remove_administrator &&
        add_administrator == other.add_administrator &&
        list_handles == other.list_handles
    end
  end
end
