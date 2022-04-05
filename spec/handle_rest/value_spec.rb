require "handle_rest"

describe HandleRest::Value do
  subject(:value) { described_class.new(expected_value) }

  let(:expected_value) { "Expected Value" }

  it "#value is expected" do
    expect(value.value).to eq expected_value
  end

  it "#type raises exception" do
    expect { value.type }.to raise_exception(RuntimeError, "this method should be overridden and return value type")
  end

  it "#== raises exception" do
    a = value
    b = value
    expect { a == b }.to raise_exception(RuntimeError, "this method should be overridden and return value type")
  end

  it "#to_json (calls #as_json) returns json" do
    expect(value.to_json).to eq({format: "string", value: expected_value}.to_json)
  end

  describe "#self.from_h" do
    let(:data) { {"format" => "format", "value" => "value"} }

    before do
      allow(HandleRest::AdminValue).to receive(:from_h).with(data["format"], data["value"]).and_return "AdminValue"
      allow(HandleRest::PublicKeyValue).to receive(:from_h).with(data["format"], data["value"]).and_return "PublicKeyValue"
      allow(HandleRest::SecretKeyValue).to receive(:from_h).with(data["format"], data["value"]).and_return "SecretKeyValue"
      allow(HandleRest::ReferenceListValue).to receive(:from_h).with(data["format"], data["value"]).and_return "ReferenceListValue"
      allow(HandleRest::EmailValue).to receive(:from_h).with(data["format"], data["value"]).and_return "EmailValue"
      allow(HandleRest::UrlValue).to receive(:from_h).with(data["format"], data["value"]).and_return "UrlValue"
      allow(HandleRest::UrnValue).to receive(:from_h).with(data["format"], data["value"]).and_return "UrnValue"
      allow(HandleRest::NilValue).to receive(:from_h).with(data["format"], data["value"]).and_return "NilValue"
    end

    it "HS_ADMIN" do
      expect(described_class.from_h("HS_ADMIN", data)).to eq "AdminValue"
    end

    it "HS_PUBKEY" do
      expect(described_class.from_h("HS_PUBKEY", data)).to eq "PublicKeyValue"
    end

    it "HS_SECKEY" do
      expect(described_class.from_h("HS_SECKEY", data)).to eq "SecretKeyValue"
    end

    it "HS_VLIST" do
      expect(described_class.from_h("HS_VLIST", data)).to eq "ReferenceListValue"
    end

    it "EMAIL" do
      expect(described_class.from_h("EMAIL", data)).to eq "EmailValue"
    end

    it "URL" do
      expect(described_class.from_h("URL", data)).to eq "UrlValue"
    end

    it "URN" do
      expect(described_class.from_h("URN", data)).to eq "UrnValue"
    end

    it "NIL" do
      expect(described_class.from_h("NIL", data)).to eq "NilValue"
    end

    it "UNKNOWN" do
      expect { described_class.from_h("UNKNOWN", data) }.to raise_exception(RuntimeError, "Value unexpected { type: UNKNOWN, data: #{data} }")
    end
  end
end
