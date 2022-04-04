require "handle_rest"

describe HandleRest::NilValue do
  let(:nil_value) { described_class.new(value) }
  let(:value) { "anything" }

  it "is derived from Value" do
    expect(nil_value).to be_a_kind_of(HandleRest::Value)
  end

  it "#nil? is true" do
    expect(nil_value.nil?).to be true
  end

  it "#type == 'NIL'" do
    expect(nil_value.type).to eq "NIL"
  end

  it "#to_s returns empty sring" do
    expect(nil_value.to_s).to eq ""
  end

  it "#self.from_s returns instance" do
    expect(described_class.from_s(value)).to eq HandleRest::Value.nil
  end

  it "#self.from_h returns instance" do
    expect(described_class.from_h("string", value)).to eq HandleRest::Value.nil
  end

  it "#self.from_h raises exception on wrong type" do
    expect { described_class.from_h("String", value) }.to raise_exception(RuntimeError, "NilValue unexpected format 'String'")
  end
end
