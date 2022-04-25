module HandleRest
  # URL Service
  #
  # A simple service to get and set a Handle's URL.
  class UrlService
    # Initialize the URL Service
    #
    #   raise RuntimeError if 'index' is not an Integer greater than zero, otherwise
    #     raise RuntimeError if 'service' is not an instance of Service, otherwise
    #       return url_service
    #
    # @param index [Integer] index of 'URL' value line (must be greater than zero).
    # @param service [Service]
    # @return [UrlService]
    # @raise [RuntimeError]
    def initialize(index, service)
      raise "Parameter 'index' is not an Integer greater than zero." unless index&.is_a?(Integer) && index > 0 # rubocop:disable Lint/SafeNavigationConsistency
      raise "Parameter 'service' is not an instance of Service." unless service&.is_a?(Service)
      @service = service
      @index = index
    end

    # Get a Handle's URL
    #
    #   raise RuntimeError if 'handle' is invalid, prefix/suffix, otherwise
    #     return nil if 'handle' does NOT exist, otherwise
    #       return nil if value line at 'index' does NOT exist, otherwise
    #         raise RuntimeError if value line at 'index' is NOT an 'URL', otherwise
    #           raise RuntimeError if get of 'url' value line at 'index' fails, otherwise
    #             return 'url' of 'index' value line.
    #
    # @param handle [String] prefix/suffix
    # @return [String] url or nil
    # @raise [RuntimeError]
    def get(handle)
      value_lines = @service.read(Handle.from_s(handle))
      index_value_lines = value_lines.select { |value_line| value_line.index == @index }
      return nil if index_value_lines.empty?
      index_value = index_value_lines[0].value
      raise "Value type '#{index_value.type}' at index '#{index_value.index}' is NOT an 'URL' type." unless index_value.type == "URL"
      index_value.value
    end

    # Set a Handle's URL
    #
    #   raise RuntimeError if 'handle' is invalid, prefix/suffix, otherwise
    #     raise RuntimeError if 'url' is invalid, scheme/protocol://host name[:port number] [/path][/query_string][/#fragment], otherwise
    #       raise RuntimeError if value line at 'index' exist and is NOT an 'URL', otherwise
    #         raise RuntimeError if set of 'url' value line at 'index' fails, otherwise
    #           return 'url' of 'index' value line
    #
    # @param handle [String] prefix/suffix
    # @param new_url [String] scheme/protocol://host name[:port number] [/path][/query_string][/#fragment]
    # @return [String] url
    # @raise [RuntimeError]
    def set(handle, new_url)
      hdl = Handle.from_s(handle)
      url = UrlValue.from_s(new_url)
      value_lines = @service.read(hdl)
      value_lines = @service.create(hdl) if value_lines.empty?
      raise "Failed to create handle '#{handle}.'" if value_lines.empty?
      index_value_lines = value_lines.select { |value_line| value_line.index == @index }
      index_value = index_value_lines[0].value unless index_value_lines.empty?
      raise "Value type '#{index_value.type}' at index '#{index_value.index}' is NOT an 'URL' type." unless index_value.nil? || index_value.type == "URL"
      old_url = index_value&.value
      index_value = nil
      value_lines = @service.write(hdl, [ValueLine.new(@index, url)])
      index_value_lines = value_lines.select { |value_line| value_line.index == @index }
      index_value = index_value_lines[0].value unless index_value_lines.empty?
      raise "Failed to add url '#{new_url}' to '#{handle}' at index '#{@index}'." if old_url.nil? && index_value.nil?
      raise "Failure deleted url '#{old_url}' from '#{handle}' at index '#{@index}'!!!" if !old_url.nil? && index_value.nil?
      raise "Failed to replace url '#{old_url}' with '#{new_url}' for '#{handle}' at index '#{@index}'." if old_url != new_url && old_url == index_value.value
      raise "Failure corrupted url '#{old_url}' with '#{index_value.value}' for '#{handle}' at index '#{@index}'!!!" if old_url != index_value.value && new_url != index_value.value
      index_value.value
    end
  end
end
