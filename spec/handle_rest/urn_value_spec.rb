require "handle_rest"

describe HandleRest::UrnValue do
  let(:urn_value) { described_class.new(expected_value) }
  let(:expected_value) { 0 }

  it "is derived from value" do
    expect(urn_value).to be_a_kind_of(HandleRest::Value)
  end

  it "type is URN" do
    expect(urn_value.type).to eq "URN"
  end

  it "#self.from_h returns instance" do
    expect(described_class.from_h("string", expected_value)).to eq urn_value
  end

  it "#self.from_h raises exception on wrong type" do
    expect { described_class.from_h("String", expected_value) }.to raise_exception(RuntimeError, "UrnValue unexpected format 'String'")
  end
end
