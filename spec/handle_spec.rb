require 'pry'
require 'handle_rest/handle'

describe Handle do
  describe '#initialize' do
    it 'can create a url handle' do
      expect { create_handle }.not_to raise_exception
    end
  end

  describe '#url' do
    it 'returns the set url' do
      handle = create_handle
      expect(handle.url).to eq('http://example.com/mytarget')
    end
  end

  describe '#handle' do
    it 'returns the handle the object was initialized with' do
      handle = create_handle
      expect(handle.handle).to eq 'myhandle'
    end
  end

  describe '#to_json' do
    it 'converts handle to json' do
      handle = create_handle
      parsed_json = JSON.parse(handle.to_json)
      expect(parsed_json[0]['index']).to eq(1)
      expect(parsed_json[0]['type']).to eq('URL')
      expect(parsed_json[0]['data']['format']).to eq('string')
      expect(parsed_json[0]['data']['value']).to eq(handle.url)
    end
  end

  def create_handle
    h = Handle.new('myhandle')
    h.url = 'http://example.com/mytarget'
    h
  end
end
