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
        faraday.request :authorization, :basic, CGI.escape(user), password
        faraday.request :json # encode req bodies as JSON and automatically set the Content-Type header
        # faraday.request :retry # retry transient failures
        faraday.response :json # decode response bodies as JSON
        # faraday.adapter :net_http # adds the adapter to the connection, defaults to `Faraday.default_adapter`
        # faraday.adapter Faraday.default_adapter
      end
    end

    def count(prefix)
      response = @conn.get("", {prefix: prefix, page: 0, pageSize: 0})
      if response.success?
        response.body["totalCount"].to_i
      else
        error = response.body
        raise "#{error["responseCode"]}: #{response_code_message(error["responseCode"])}"
      end
    end

    def index(prefix, page = -1, page_size = -1)
      response = @conn.get("", {prefix: prefix, page: page, pageSize: page_size})
      if response.success?
        response.body["handles"].map { |h| HandleRest::Identifier.from_s(h) }
      else
        error = response.body
        raise "#{error["responseCode"]}: #{response_code_message(error["responseCode"])}"
      end
    end

    # get handle value lines by id
    #
    # @param handle_id [String] The handle's identifier with prefix,
    #   e.g. `2027/mdp.390150123456789`
    # @return [Handle] The handle, or nil if the handle can't be found.
    def get(id)
      response = @conn.get(id.to_s)
      if response.success?
        response.body["values"].map { |v| HandleRest::ValueLine.from_h(v) }
      else
        error = response.body
        raise "#{error["responseCode"]}: #{response_code_message(error["responseCode"])}"
      end
    end

    #
    #
    # @param handle [Handle] The handle to create
    # @return [Boolean] true if the handle was created successfully
    # @raise [RuntimeError] if the handle server returns an error. The exception
    # text is the error string from the handle server.
    def put(id, value_lines, update = false)
      handle = id.to_s
      handle += "?index=various" if update
      response = @conn.put(handle, value_lines)
      if response.success?
        true
      else
        error = response.body
        raise "#{error["responseCode"]}: #{response_code_message(error["responseCode"])}"
      end
    end

    # Deletes a handle
    #
    # @param handle_id [String] The handle's identifier with prefix,
    #   e.g. `2027/mdp.390150123456789`
    # @return [Boolean] True if the handle was successfully deleted,
    #   or false otherwise
    def delete(id)
      response = @conn.delete(id.to_s)
      if response.success?
        true
      else
        error = response.body
        raise "#{error["responseCode"]}: #{response_code_message(error["responseCode"])}"
      end
    end

    private

    def response_code_message(response_code)
      case response_code
      when 1
        "Success"
      when 2
        "Error"
      when 3
        "Server Too Busy"
      when 4
        "Protocol Error"
      when 5
        "Operation Not Supported"
      when 6
        "Recursion Count Too High"
      when 7
        "Server Read-only"
      when 100
        "Handle Not Found"
      when 101
        "Handle Already Exists"
      when 102
        "Invalid Handle"
      when 200
        "Values Not Found"
      when 201
        "Value Already Exists"
      when 202
        "Invalid Value"
      when 300
        "Out of Date Site Info"
      when 301
        "Server Not Responsible"
      when 302
        "Service Referral"
      when 303
        "Prefix Referral"
      when 400
        "Invalid Admin"
      when 401
        "Insufficient Permissions"
      when 402
        "Authentication Needed"
      when 403
        "Authentication Failed"
      when 404
        "Invalid Credential"
      when 405
        "Authentication Timed Out"
      when 406
        "Authentication Error"
      when 500
        "Session Timeout"
      when 501
        "Session Failed"
      when 502
        "Invalid Session Key"
      when 504
        "Invalid Session Setup Request"
      when 505
        "Session Duplicate Msg Rejected"
      else
        "response code message missing"
      end
    end
  end
end
