require 'faraday'

# Faraday-backed interface to Handle REST API
class HandleService
  def initialize(url:, user:, password:, ssl_verify: true)
    @conn = Faraday.new(url: url,
                        ssl: { verify: ssl_verify }) do |faraday|
      faraday.request :retry
      faraday.request :basic_auth, URI.escape(user, /[:%]/), password
      faraday.adapter Faraday.default_adapter
    end
  end

  def create(handle)
    response = @conn.put { |req| build_req(handle, req) }

    if response.success?
      true
    else
      error = JSON.parse(response.body)
      raise "#{error['responseCode']}: #{error['message']}"
    end
  end

  def get(handle_id)
    response = @conn.get(handle_id)
    Handle.from_json(response.body) if response.success?
  end

  def delete(handle)
    @conn.delete(handle.id).success?
  end

  private

  def build_req(handle, req)
    req.url handle.id.to_s
    req.headers['Content-Type'] = 'application/json'
    req.body = handle.to_json
  end
end
