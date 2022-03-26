require "handle_rest"

describe HandleRest::Handle do
  describe "#initialize" do
    it "can create a handle" do
      expect { described_class.new("myhandle") }.not_to raise_exception
    end

    it "can pass a url" do
      handle = described_class.new("myhandle", url: TEST_URL)
      expect(handle.url).to eq(TEST_URL)
    end
  end

  describe "#url" do
    it "can set and return the set url" do
      handle = described_class.new("myhandle")
      handle.url = TEST_URL
      expect(handle.url).to eq(TEST_URL)
    end
  end

  describe "#handle" do
    it "returns the handle the object was initialized with" do
      handle = described_class.new("myhandle", url: TEST_URL)
      expect(handle.id).to eq "myhandle"
    end
  end

  describe "#to_json" do
    let(:array_handle_hash) do
      [
        {
          "index" => 1,
          "type" => "URL",
          "data" => {
            "format" => "string",
            "value" => TEST_URL
          }
        }
      ]
    end

    it "converts handle to json" do
      handle = described_class.new("foo", url: "http://foo.com/bar")
      parsed_json = JSON.parse(handle.to_json)
      expect(parsed_json[0]).to eq array_handle_hash[0]
    end
  end

  describe "#from_json" do
    let(:handle_server_response) do
      {
        responseCode: 1,
        handle: "9999/test",
        values: [
          {
            index: 1,
            type: "URL",
            data: {
              format: "string",
              value: TEST_URL
            }
          }
        ],
        ttl: 86400,
        timestamp: "2016-05-09T19:19:53Z"
      }
    end

    it "parses handle from json" do
      handle = described_class.from_json(handle_server_response.to_json)
      expect(handle).eql?(described_class.new("9999/test", url: TEST_URL))
    end
  end
end
