require "json"

module HandleRest
  class Handle
    private_class_method :new

    def initialize(identifier, value_lines, handle_service, factory_handle_service)
      raise "non-identifier" unless identifier.is_a?(Identifier)
      raise "non-value line" unless value_lines.all? { |value_line| value_line.is_a?(ValueLine) }
      raise "no admin value line" unless value_lines.any? { |value_line| value_line.value.is_a?(AdminValue) }
      raise "non-handle service" unless handle_service.is_a?(HandleService)
      raise "factory non-handle service" unless factory_handle_service.is_a?(HandleService)
      @identifier = identifier
      @value_lines = value_lines
      @handle_service = handle_service
      @factory_handle_service = factory_handle_service
    end

    def url
      url_value_lines = @value_lines.select { |value_line| value_line.value.is_a?(UrlValue) }
      return nil if url_value_lines.empty?

      url_value_line = url_value_lines.select { |value_line| value_line.index == 1 }
      raise "url not found" if url_value_line.nil?

      url_value_lines[0].value.value
    end

    def url=(url)
      url_value_lines = @value_lines.select { |value_line| value_line.value.is_a?(UrlValue) }

      if url_value_lines.empty?
        url_value_line = ValueLine.new(1, UrlValue.new(url))
        @handle_service.put(@identifier, url_value_line)
        @value_lines = @factory_handle_service.get(@identifier)
        url_value_lines = @value_lines.select { |value_line| value_line.value.is_a?(UrlValue) }
        raise "url not found" if url_value_lines.empty?
      end

      url_value_line = url_value_lines.select { value_line.value.value == url }
      return if !url_value_line.nil?

      url_value_line = url_value_lines[0]
      url_value_line.value.value = url
      @handle_service.put(@identifier, url_value_line)
      @value_lines = @factory_handle_service.get(@identifier)
      url_value_lines = @value_lines.select { |value_line| value_line.value.is_a?(UrlValue) }
      raise "url not found" if url_value_lines.empty?

      url_value_line = url_value_lines.select { value_line.value.value == url }
      return if !url_value_line.nil?

      raise "url not found"
    end
  end
end
