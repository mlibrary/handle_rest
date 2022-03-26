require "handle_rest"

describe HandleRest::ReferenceListValue do
  let(:reference_list_value) { described_class.new(expected_value) }
  let(:expected_value) { 0 }

  it "is derived from value" do
    expect(reference_list_value).to be_a_kind_of(HandleRest::Value)
  end

  it "type is VLIST" do
    expect(reference_list_value.type).to eq "VLIST"
  end
end
