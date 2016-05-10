require 'json'

# wraps the data structures needed to create a handle object
class Handle
  attr_reader :id
  attr_accessor :url

  def initialize(id, url: nil)
    @id = id
    self.url = url
  end

  def self.from_json(json)
    parsed = JSON.parse(json)
    Handle.new(parsed['handle'],
               url: parsed['values']
                     .find { |v| v['type'] == 'URL' }['data']['value'])
  end

  def to_json
    [{ 'index' => 1, 'type' => 'URL',
       'data' => {
         'format' => 'string',
         'value' => url
       }
    }].to_json
  end
end
