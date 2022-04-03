# Handle Rest Module
module HandleRest
  # Serialize
  #
  # @param boolean [Boolean]
  # @return [String] "1" if true or "0" if false
  # @raise [RuntimeError] if boolean not true or false.
  def self.boolean_to_character(boolean)
    case boolean
    when true
      "1"
    when false
      "0"
    else
      raise("'#{boolean}' to character must be true or false.")
    end
  end

  # Deserialize
  #
  # @param character [String]
  # @return [Boolean] true if "1" or false if "0"
  # @raise [RuntimeError] if character not "1" or "0".
  def self.character_to_boolean(character)
    case character
    when "1"
      true
    when "0"
      false
    else
      raise("'#{character}' to boolean must be '1' or '0'.")
    end
  end
end

require_relative "handle_rest/handle"
require_relative "handle_rest/identity"
require_relative "handle_rest/permission_set"
require_relative "handle_rest/admin_permission_set"
require_relative "handle_rest/value"
require_relative "handle_rest/admin_value"
require_relative "handle_rest/email_value"
require_relative "handle_rest/public_key_value"
require_relative "handle_rest/reference_list_value"
require_relative "handle_rest/secert_key_value"
require_relative "handle_rest/url_value"
require_relative "handle_rest/urn_value"
require_relative "handle_rest/value_line"
require_relative "handle_rest/handle_service"
require_relative "handle_rest/service"
require_relative "handle_rest/url_service"
