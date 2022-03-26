require "handle_rest"

describe HandleRest::EmailValue do
  let(:email_value) { described_class.new(expected_value) }
  let(:expected_value) { 0 }

  it "is derived from value" do
    expect(email_value).to be_a_kind_of(HandleRest::Value)
  end

  it "type is EMAIL" do
    expect(email_value.type).to eq "EMAIL"
  end
end
