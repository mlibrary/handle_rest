require "handle_rest"

describe HandleRest::PublicKeyValue do
  let(:public_key_value) { described_class.new(expected_value) }
  let(:expected_value) { 0 }

  it "is derived from value" do
    expect(public_key_value).to be_a_kind_of(HandleRest::Value)
  end

  it "type is HS_PUBKEY" do
    expect(public_key_value.type).to eq "HS_PUBKEY"
  end

  it "#self.from_h returns instance" do
    expect(described_class.from_h("string", expected_value)).to eq public_key_value
  end

  it "#self.from_h raises exception on wrong type" do
    expect { described_class.from_h("String", expected_value) }.to raise_exception(RuntimeError, "PublicKeyValue unexpected format 'String'")
  end
end
