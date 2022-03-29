require "json"

module HandleRest
  # wraps the data structures needed to create a handle object
  class Handle
    # @return [String] The handle's identifier with prefix, for example
    # `2027/mdp.390150123456789`
    attr_reader :id

    # @return [String] The URL the handle resolves to
    attr_accessor :url

    # Create a new handle; it is not persisted by default (use
    # {HandleService#create} for that)
    #
    # @param id [String] The handle's identifier with prefix, for example
    # `2027/mdp.390150123456789`
    # @param url [String] The URL the handle should resolve to
    # @return [Handle] a new handle.
    def initialize(id, url: nil)
      @id = id
      self.url = url
    end

    # Initializes a new handle from the JSON representation as
    # returned by the handle REST API.
    def self.from_json(json)
      parsed = JSON.parse(json)
      Handle.new(parsed["handle"],
        url: parsed["values"]
              .find { |v| v["type"] == "URL" }["data"]["value"])
    end

    # Converts a handle to a JSON representation suitable for
    # passing to the handle REST API.
    def to_json
      [{"index" => 1, "type" => "URL",
        "data" => {
          "format" => "string",
          "value" => url
        }}].to_json
    end

    def ==(other)
      id == other.url &&
        url == other.url
    end
  end
end
