require "faraday"

module HandleRest
  # Faraday-backed interface to Handle REST API
  class HandleService
    # Sets up a new connection to a Handle server REST API
    #
    # @param url [String] The URL to the REST API, e.g.
    #   :`http://example.com:8000/api/handles`
    # @param user [String] A user with permission to create handles, e.g.
    #   `300:0.NA/ADMIN`
    # @param password [String] The password for the administrative user.
    # Currently, only secret key authentication is implemented.
    # @param ssl_verify [Boolean] (Use with care, and never in production) - set
    # to false only if the REST API is expected to use an invalid certificate.
    # @return [HandleService] a usable service object
    def initialize(url:, user:, password:, ssl_verify: true)
      @conn = Faraday.new(url: url,
        ssl: {verify: ssl_verify}) do |faraday|
        # faraday.request :retry
        # faraday.request :basic_auth, CGI.escape(user), password
        faraday.request :authorization, :basic, CGI.escape(user), password
        faraday.adapter Faraday.default_adapter
      end
    end

    # Creates a new handle
    #
    # @param handle [Handle] The handle to create
    # @return [Boolean] true if the handle was created successfully
    # @raise [RuntimeError] if the handle server returns an error. The exception
    # text is the error string from the handle server.
    def create(handle)
      response = @conn.put { |req| build_req(handle, req) }

      if response.success?
        true
      else
        error = JSON.parse(response.body)
        raise "#{error["responseCode"]}: #{error["message"]}"
      end
    end

    # Looks up a handle by id
    #
    # @param handle_id [String] The handle's identifier with prefix,
    #   e.g. `2027/mdp.390150123456789`
    # @return [Handle] The handle, or nil if the handle can't be found.
    def get(handle_id)
      response = @conn.get(handle_id)
      Handle.from_json(response.body) if response.success?
    end

    # Deletes a handle
    #
    # @param handle_id [String] The handle's identifier with prefix,
    #   e.g. `2027/mdp.390150123456789`
    # @return [Boolean] True if the handle was successfully deleted,
    #   or false otherwise
    def delete(handle_id)
      @conn.delete(handle_id).success?
    end

    private

    def build_req(handle, req)
      req.url handle.id.to_s
      req.headers["Content-Type"] = "application/json"
      req.body = handle.to_json
    end
  end
end
