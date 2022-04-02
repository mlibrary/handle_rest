require "handle_rest"

describe HandleRest::ReferenceListValue do
  let(:reference_list_value) { described_class.new(expected_value) }
  let(:expected_value) { [identity] }
  let(:identity) { HandleRest::Identity.from_s("300:PREFIX/SUFIX") }

  it "is derived from value" do
    expect(reference_list_value).to be_a_kind_of(HandleRest::Value)
  end

  it "#type is HS_VLIST" do
    expect(reference_list_value.type).to eq "HS_VLIST"
  end

  it "#== equivalent to self" do
    a = reference_list_value
    b = reference_list_value
    expect(a == b).to be true
  end

  it "#== equivalent to copy" do
    a = reference_list_value
    b = described_class.new(a.value)
    expect(a == b).to be true
  end

  it "#== not equivalent to other" do
    a = reference_list_value
    b = described_class.new([])
    expect(a == b).to be false
  end

  it "#as_json returns hash" do
    expect(reference_list_value.as_json).to eq({format: "vlist", value: reference_list_value.value.map { |v| {index: v.index.to_i, handle: v.handle.to_s} }})
  end

  it "#self.from_h return instance" do
    expect(described_class.from_h("vlist", [{"index" => identity.index.to_s, "handle" => identity.handle.to_s}])).to eq reference_list_value
  end

  it "#self.from_h raises exception on wrong type" do
    expect { described_class.from_h("VList", [{"index" => identity.index.to_s, "handle" => identity.handle.to_s}]) }.to raise_exception(RuntimeError, "ReferenceListValue unexpected format 'VList'")
  end
end
