require "handle_rest"

describe HandleRest::NilValueLine do
  let(:nil_value_line) { described_class.new(1, HandleRest::UrlValue.from_s("https://www.umich.edu"), time_to_live: 9999, permissions: HandleRest::PermissionSet.from_s("1111")) }
  let(:index) { nil_value_line.index }
  let(:value) { nil_value_line.value }
  let(:permissions) { nil_value_line.permissions }
  let(:ttl) { nil_value_line.time_to_live }

  it "is derived from ValueLine" do
    expect(nil_value_line).to be_a_kind_of(HandleRest::ValueLine)
  end

  it "#nil? is true" do
    expect(nil_value_line.nil?).to be true
  end

  it "index == 0" do
    expect(nil_value_line.index).to eq 0
  end

  it "value == Value.nil" do
    expect(nil_value_line.value).to eq HandleRest::Value.nil
  end

  it "permission set == '0000'" do
    expect(nil_value_line.permissions).to eq HandleRest::PermissionSet.from_s("0000")
  end

  it "time to live == 86400" do
    expect(nil_value_line.time_to_live).to eq 86400
  end

  it "#as_json returns hash" do
    expect(nil_value_line.as_json).to eq({index: index, type: value.type, data: value, ttl: ttl, permissions: permissions.to_s})
  end

  it "#to_json calls #as_json" do
    expect(nil_value_line.to_json).to eq({index: index, type: value.type, data: value, ttl: ttl, permissions: permissions.to_s}.to_json)
  end

  it "#self.from_h return instance" do
    expect(described_class.from_h({"index" => index.to_s, "type" => value.type, "data" => {"format" => "string", "value" => value.value.to_s}, "permissions" => permissions.to_s, "time_to_live" => ttl})).to eq nil_value_line
  end
end
