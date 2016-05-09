require 'json'

# wraps the data structures needed to create a handle object
class Handle
  attr_reader :id
  attr_accessor :url

  def initialize(id, url: nil)
    @id = id
    self.url = url
  end

  def from_json()
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
