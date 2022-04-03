module HandleRest
  # Handle Service
  class UrlService
    # Initialize
    #
    # @param service [Service]
    # @param index [Integer] default url value line index
    # @return [UrlService]
    # @raise [RuntimeError]
    def initialize(service, index: 1)
      raise "Parameter serive is not an instance of Service." unless service&.is_a?(Service)
      raise "Parameter index is not an Integer greater than zero." unless !index.nil? && index.is_a?(Integer) && index > 0
      @service = service
      @default_index = index
    end

    # Get
    #
    # @param handle [String]
    # @return [String|nil] url
    # @raise [RuntimeError]
    def get(handle)
      value_lines = @service.get(Handle.from_s(handle))
      url_value_lines = value_lines.select { |value_line| value_line.value.is_a?(UrlValue) }

      url_value_lines[0]&.value&.value
    end

    # Set
    #
    # @param handle [String]
    # @param url [String]
    # @return [String] url
    # @raise [RuntimeError]
    def set(handle, url)
      _hdl = Handle.from_s(handle)
      url_value = UrlValue.from_s(url)
      url_value.to_s
    end
  end
end
