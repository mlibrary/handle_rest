require "handle_rest"

describe HandleRest::Value do
  it "value is expected" do
    expect(described_class.new("expected value").value).to eq "expected value"
  end

  it "attribute reader raises exception" do
    expect { described_class.new("expected value").type }.to raise_exception(RuntimeError, "this method should be overridden and return value type")
  end
end
