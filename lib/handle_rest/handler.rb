require "json"

module HandleRest
  # wraps calls to the handle service for a handle identifier
  class Handler
    # Create a new handler
    #
    # @param id [String] Handle Identifier prefix/suffix,
    # for example `2027/mdp.390150123456789`
    # @return [Handler] a new handler.
    def initialize(id)
      @id = id
    end

    def create(handle_identifier, admin_value_line)
    end

    def add
    end

    def modify
    end

    def remove
    end

    def delete
    end
  end
end
