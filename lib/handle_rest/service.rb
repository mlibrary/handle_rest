module HandleRest
  # Handle Service
  class Service
    # Initialize
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

    # Get
    #
    # @param handle [Handle]
    # @return [Array<ValueLine>]
    # @raise [RuntimeError]
    def get(handle)
      raise "Parameter 'handle' must be an instance of Handle." unless handle.is_a?(Handle)
      @handle_service.get(handle)
    end

    # Create
    #
    # @param handle [Handle]
    # @return [Array<ValueLine>]
    # @raise [RuntimeError]
    def create(handle)
      raise "Parameter 'handle' must be an instance of Handle." unless handle.is_a?(Handle)
      value_lines = get(handle)
      return value_lines unless value_lines.empty?

      @handle_service.set(handle, @default_value_lines)
      get(handle)
    end

    # Set
    #
    # @param handle [Handle]
    # @param value_lines [Array<ValueLine>]
    # @return [Array<ValueLine>]
    # @raise [RuntimeError]
    def set(handle, value_lines)
      raise "Parameter 'handle' must be an instance of Handle." unless handle.is_a?(Handle)
      raise "Parameter 'value_lines' must be an Array<ValueLine>." unless arrayValueLines?(value_lines)
      return get(handle) if value_lines.empty?

      create(handle)
      @handle_service.set(handle, value_lines, add_replace: true)
      get(handle)
    end

    # Delete
    #
    # @param handle [Handle]
    # @param indices [Array<Integer>]
    # @param value_lines [Array<ValueLine>]
    # @return [Array<ValueLine>]
    # @raise [RuntimeError]
    def delete(handle, indices: [], value_lines: [])
      raise "Parameter 'handle' must be an instance of Handle." unless handle.is_a?(Handle)
      raise "Parameter 'indices' must be an Array<Integer> where index > 0." unless arrayIndices?(indices)
      raise "Parameter 'value_lines' must be an Array<ValueLine>." unless arrayValueLines?(value_lines)
      handle_value_lines = get(handle)
      return [] if handle_value_lines.empty?

      remove_indices = (indices + value_lines.map(&:index)).uniq
      return @handle_service.delete(handle) if remove_indices.empty?

      remove_value_lines = []
      remaining_value_lines = []
      handle_value_lines.each do |value_line|
        if remove_indices.include?(value_line.index)
          remove_value_lines << value_line
        else
          remaining_value_lines << value_line
        end
      end
      return remaining_value_lines if remove_value_lines.empty?

      if hasAdminValueLine?(remaining_value_lines)
        @handle_service.delete(handle, remove_value_lines.map(&:index))
      else
        @handle_service.delete(handle)
      end
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
