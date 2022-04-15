require "faraday"
require "faraday_middleware"

module HandleRest
  # Handle Service
  #
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
    # @return [HandleService]
    # @raise [RuntimeError] if faraday initialize returns an error.
    def initialize(url:, user:, password:, ssl_verify: true)
      @conn = Faraday.new(url: url,
        ssl: {verify: ssl_verify}) do |faraday|
        faraday.request :basic_auth, CGI.escape(user), password
        faraday.request :json # encode req bodies as JSON and automatically set the Content-Type header
        faraday.request :retry # retry transient failures
        faraday.response :json # decode response bodies as JSON
        faraday.adapter :net_http # adds the adapter to the connection, defaults to `Faraday.default_adapter`
      end
    end

    # Prefix Handle Count
    #
    # @param prefix [String]
    # @return [Integer]
    # @raise [RuntimeError] if the handle server returns an error.
    def count(prefix)
      response = @conn.get("", {prefix: prefix, page: 0, pageSize: 0})
      if response.success?
        response.body["totalCount"].to_i
      else
        raise_response_error(response)
      end
    end

    # Prefix Handle Index
    #
    # @param prefix [String]
    # @param page [Integer] pagination page number
    # @param page_size [Integer] pagination page size
    # @return [[Handle]]
    # @raise [RuntimeError] if the handle server returns an error.
    def index(prefix, page = -1, page_size = -1)
      response = @conn.get("", {prefix: prefix, page: page, pageSize: page_size})
      if response.success?
        response.body["handles"].map { |h| HandleRest::Handle.from_s(h) }
      else
        raise_response_error(response)
      end
    end

    # Get Handle Value Lines
    #
    # @param handle [Handle]
    # @return [[ValueLine]]
    # @raise [RuntimeError] if the handle server returns an error.
    def get(handle)
      response = @conn.get(handle.to_s)
      if response.success?
        response.body["values"].map { |v| HandleRest::ValueLine.from_h(v) }
      else
        case response_code(response)
        when 100
          []
        else
          raise_response_error(response)
        end
      end
    end

    # Post Handle Value Lines
    #
    # @param handle [Handle] The handle to recreate
    # @param value_lines [[ValueLine]]
    # @return [Boolean] true
    # @raise [RuntimeError] if the handle server returns an error.
    def post(handle, value_lines)
      response = @conn.put(handle.to_s, value_lines)
      if response.success?
        true
      else
        raise_response_error(response)
      end
    end

    # Patch Handle Value Lines
    #
    # @param handle [Handle] The handle to create/modify
    # @return [Boolean] true
    # @raise [RuntimeError] if the handle server returns an error.
    def patch(handle, value_lines)
      response = @conn.put(handle.to_s + "?index=various", value_lines)
      if response.success?
        true
      else
        raise_response_error(response)
      end
    end

    # Remove Handle Value Lines At Indices
    #
    # @param handle [Handle]
    # @param indices [Array<Integer] with values > 0
    # @return [Boolean] true
    # @raise [RuntimeError] if the handle server returns an error.
    def remove(handle, indices = [])
      response = @conn.delete(handle.to_s, indices)
      if response.success?
        true
      else
        raise_response_error(response)
      end
    end

    # Delete Handle
    #
    # @param handle [Handle]
    # @return [Boolean] true
    # @raise [RuntimeError] if the handle server returns an error.
    def delete(handle)
      response = @conn.delete(handle.to_s)
      if response.success?
        true
      else
        raise_response_error(response)
      end
    end

    private

    # Raise Response Error
    #
    # @param response [Faraday::Response]
    # @raise [RuntimeError]
    def raise_response_error(response)
      error = response.body
      raise "#{error["handle"]} - #{error["responseCode"]}: #{response_code_message(error["responseCode"])}"
    end

    # Response Code
    #
    # @param response [Faraday::Response]
    # @return [Integer] code
    def response_code(response)
      response.body["responseCode"]&.to_i || 0
    end

    # Response Code Message Map
    #
    # @param response_code [Integer]
    # @return [String] message
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
        "Response Code Message Missing!"
      end
    end
  end
end
