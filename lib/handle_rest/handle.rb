require 'json'

# wraps the data structures needed to create a handle object
class Handle
  attr_reader :handle
  attr_accessor :url

  def initialize(handle, url: nil)
    @handle = handle
    self.url = url
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
