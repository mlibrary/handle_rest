module HandleRest
  # Service
  #
  # A simple service to create and delete handles and read, write, and remove its value lines.
  class Service
    # Initialize the Service
    #
    #   raise RuntimeError if 'value_lines' does NOT have at least one AdminValueLine, otherwise
    #     raise RuntimeError if 'handle_service' is not an instance of HandleService, otherwise
    #       return service
    #
    # @param value_lines [Array<ValueLine>] default value lines for new handles
    # @param handle_service [HandleService]
    # @return [Service]
    # @raise [RuntimeError]
    def initialize(value_lines, handle_service)
      raise "Parameter 'value_lines' must be an Array<ValueLine> with at least one AdminValue." unless hasAdminValueLine?(value_lines)
      raise "Parameter 'handle_service' must be an instance of HandleService." unless handle_service&.is_a?(HandleService)
      @default_value_lines = value_lines
      @handle_service = handle_service
    end

    # Create a new Handle with default value lines
    #
    #   raise RuntimeError if 'handle' is invalid, index:prefix/suffix, otherwise
    #     return value lines of 'handle' if 'handle' exist, otherwise
    #       raise RuntimeError if create new 'handle' fails, otherwise
    #         return value lines of new 'handle' a.k.a. default value lines
    #
    # @param handle [Handle]
    # @return [Array<ValueLine>]
    # @raise [RuntimeError]
    def create(handle)
      raise "Parameter 'handle' must be an instance of Handle." unless handle.is_a?(Handle)
      value_lines = read(handle)
      return value_lines unless value_lines.empty?

      @handle_service.post(handle, @default_value_lines)
      read(handle)
    end

    # Delete a Handle
    #
    #   raise RuntimeError if 'handle' is invalid, index:prefix/suffix, otherwise
    #     raise RuntimeError if delete 'handle' fails, otherwise
    #       return deleted value lines of 'handle'
    #
    # @param handle [Handle]
    # @return [Array<ValueLine>]
    # @raise [RuntimeError]
    def delete(handle)
      raise "Parameter 'handle' must be an instance of Handle." unless handle.is_a?(Handle)
      value_lines = read(handle)
      return [] if value_lines.empty?

      @handle_service.delete(handle)
      value_lines
    end

    # Read a Handle's Value Lines
    #
    #   raise RuntimeError if 'handle' is invalid, index:prefix/suffix, otherwise
    #     return [] if 'handle' does NOT exist, otherwise
    #       raise RuntimeError if read 'handle' fails, otherwise
    #         return value lines of 'handle'
    #
    # @param handle [Handle]
    # @return [Array<ValueLine>]
    # @raise [RuntimeError]
    def read(handle)
      raise "Parameter 'handle' must be an instance of Handle." unless handle.is_a?(Handle)
      @handle_service.get(handle)
    end

    # Write a Handle's value lines
    #
    #   raise RuntimeError if 'handle' is invalid, index:prefix/suffix, otherwise
    #     raise RuntimeError if write 'handle' fails, otherwise
    #       return value lines of 'handle'
    #
    # @param handle [Handle]
    # @param value_lines [Array<ValueLine>]
    # @return [Array<ValueLine>]
    # @raise [RuntimeError]
    def write(handle, value_lines)
      raise "Parameter 'handle' must be an instance of Handle." unless handle.is_a?(Handle)
      raise "Parameter 'value_lines' must be an Array<ValueLine>." unless arrayValueLines?(value_lines)
      return read(handle) if value_lines.empty?

      create(handle)
      @handle_service.put(handle, value_lines)
      read(handle)
    end

    # Remove a Handle's value lines
    #
    #   raise RuntimeError if 'handle' is invalid, index:prefix/suffix, otherwise
    #     raise RuntimeError if 'indices' is not an Array<Integer> of integers > 0, otherwise
    #       raise RuntimeError if remove value lines of 'handle' at 'indices' fails, otherwise
    #         return value lines of 'handle'
    #
    # @param handle [Handle]
    # @param indices [Array<Integer>]
    # @return [Array<ValueLine>]
    # @raise [RuntimeError]
    def remove(handle, indices)
      raise "Parameter 'handle' must be an instance of Handle." unless handle.is_a?(Handle)
      raise "Parameter 'indices' must be an Array<Integer> of integers > 0." unless arrayIndices?(indices)
      value_lines = read(handle)
      return value_lines if value_lines.empty? || indices.empty?

      remove_value_lines = value_lines.map { |value_line| value_line if indices.include?(value_line.index) }.compact
      return value_lines if remove_value_lines.empty?

      remove_indices = remove_value_lines.map(&:index).compact
      @handle_service.delete(handle, remove_indices)
      read(handle)
    end

    private

    def arrayIndices?(indices)
      indices.all? { |index| index.is_a?(Integer) && index > 0 }
    rescue
      false
    end

    def arrayValueLines?(value_lines)
      value_lines.all? { |value_line| value_line.is_a?(ValueLine) }
    rescue
      false
    end

    def hasAdminValueLine?(value_lines)
      admin_value_line_count = 0
      value_lines.each do |value_line|
        return false unless value_line.is_a?(ValueLine)
        admin_value_line_count += 1 if value_line.value.is_a?(AdminValue)
      end
      admin_value_line_count > 0
    rescue
      false
    end
  end
end
