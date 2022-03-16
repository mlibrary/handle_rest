# frozen_string_literal: true

require 'handle_rest/handle'

describe Handle do # rubocop:disable Metrics/BlockLength
  describe '#initialize' do
    it 'can create a handle' do
      expect { described_class.new('myhandle') }.not_to raise_exception
    end

    it 'can pass a url' do
      handle = described_class.new('myhandle', url: TEST_URL)
      expect(handle.url).to eq(TEST_URL)
    end
  end

  describe '#url' do
    it 'can set and return the set url' do
      handle = described_class.new('myhandle')
      handle.url = TEST_URL
      expect(handle.url).to eq(TEST_URL)
    end
  end

  describe '#handle' do
    it 'returns the handle the object was initialized with' do
      handle = described_class.new('myhandle', url: TEST_URL)
      expect(handle.id).to eq 'myhandle'
    end
  end

  describe '#to_json' do
    it 'converts handle to json' do # rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength
      handle = described_class.new('foo', url: 'http://foo.com/bar')
      parsed_json = JSON.parse(handle.to_json)
      expect(parsed_json[0]['index']).to eq(1)
      expect(parsed_json[0]['type']).to eq('URL')
      expect(parsed_json[0]['data']['format']).to eq('string')
      expect(parsed_json[0]['data']['value']).to eq(TEST_URL)
    end
  end

  describe '#from_json' do
    it 'parses handle from json' do  # rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength
      json = %( {"responseCode":1,"handle":"9999/test", "values":[{"index":1,
          "type":"URL","data":{"format":"string","value":"#{TEST_URL}"},
          "ttl":86400,"timestamp":"2016-05-09T19:19:53Z"}]})

      handle = described_class.from_json(json)
      expect(handle.id).to eq('9999/test')
      expect(handle.url).to eq(TEST_URL)
    end
  end
end
