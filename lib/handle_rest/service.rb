module HandleRest
  # Handle Service
  class Service
    # Initialize
    #
    # @return [Service]
    def initialize(handle_service_rest_url,
      naming_authority_identifier, admin_identity, admin_password,
      root_naming_authority_identifier, root_admin_identity, root_admin_password,
      ssl_verify = true)
      raise "non-url: handle service rest url" unless /^\A.+\z$/i.match?(handle_service_rest_url&.strip)
      raise "non-handle: naming authority handle" unless naming_authority_identifier.is_a?(Handle)
      raise "non-identity: admin identity" unless admin_identity.is_a?(Identity)
      raise "non-handle: root naming authority handle" unless root_naming_authority_identifier.is_a?(Handle)
      raise "non-identity: root admin identity" unless root_admin_identity.is_a?(Identity)
      raise "non-boolean: ssl verify" unless [true, false].include?(ssl_verify)

      @url = handle_service_rest_url.strip
      @na = naming_authority_identifier
      @adm = admin_identity
      @pw = admin_password
      @root_na = root_naming_authority_identifier
      @root_adm = root_admin_identity
      @root_pw = root_admin_password
      @ssl_verify = ssl_verify

      @hs = HandleService.new(url: @url, user: @adm, password: @pw, ssl_verify: @ssl_verify)
      @root_hs = HandleService.new(url: @url, user: @root_adm, password: @root_pw, ssl_verify: @ssl_verify)
    end

    # Get
    #
    # @return
    def get_url(handle_identifier)
      raise "non-handle: handle" unless handle_identifier.is_a?(Handle)
      value_lines = @hs.get(handle_identifier)
      url_value_lines = value_lines.select { |value_line| value_line.value.is_a?(UrlValue) }
      url_value_lines[0]&.value&.value
    end

    # Set
    #
    # @return
    def set_url(handle_identifier, handle_url)
      raise "non-handle: handle" unless handle_identifier.is_a?(Handle)
      raise "non-url: handle url" unless /^\A.+\z$/i.match?(handle_url&.strip)
      raise "non-handle: handle" unless handle_identifier.is_a?(Handle)
      value_lines = [
        ValueLine.new(100, AdminValue.new(@root_adm.index, AdminPermissionSet.from_s("111111111111"), @root_adm.handle)),
        ValueLine.new(101, AdminValue.new(@adm.index, AdminPermissionSet.from_s("110011110001"), @adm.handle)),
        ValueLine.new(1, UrlValue.new(handle_url.strip))
      ]
      @hs.put(handle_identifier, value_lines)
      handle_url.strip
    end

    # Delete
    #
    # @return
    def delete(handle_identifier)
      raise "non-handle: handle" unless handle_identifier.is_a?(Handle)
      @hs.delete(handle_identifier)
      nil
    end
  end
end
