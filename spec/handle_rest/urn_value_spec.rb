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
end
