require "handle_rest"

describe HandleRest::EmailValue do
  let(:email_value) { described_class.new(expected_value) }
  let(:expected_value) { 0 }

  it "is derived from value" do
    expect(email_value).to be_a_kind_of(HandleRest::Value)
  end

  it "#type is EMAIL" do
    expect(email_value.type).to eq "EMAIL"
  end

  it "#self.from_h returns instance" do
    expect(described_class.from_h("string", expected_value)).to eq email_value
  end

  it "#self.from_h raises exception on wrong type" do
    expect { described_class.from_h("String", expected_value) }.to raise_exception(RuntimeError, "EmailValue unexpected format 'String'")
  end
end
