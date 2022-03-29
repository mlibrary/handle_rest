require "handle_rest"

describe HandleRest::UrlValue do
  let(:url_value) { described_class.new(expected_value) }
  let(:expected_value) { 0 }

  it "is derived from value" do
    expect(url_value).to be_a_kind_of(HandleRest::Value)
  end

  it "type is URL" do
    expect(url_value.type).to eq "URL"
  end
end
