module HandleRest
  def self.boolean_to_character(boolean)
    if boolean
      "1"
    else
      "0"
    end
  end

  def self.character_to_boolean(character)
    if character == "1"
      true
    elsif character == "0"
      false
    else
      raise("Must be zero or one.")
    end
  end
end

require_relative "handle_rest/handle"

require_relative "handle_rest/identifier"
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
