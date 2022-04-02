require "handle_rest"

describe HandleRest::AdminValue do
  let(:admin_value) { described_class.new(index, permissions, handle) }
  let(:index) { 300 }
  let(:permissions) { HandleRest::AdminPermissionSet.new }
  let(:handle) { HandleRest::Handle.from_s("PREFIX/ADMIN") }

  it "is derived from value" do
    expect(admin_value).to be_a_kind_of(HandleRest::Value)
  end

  it "type HS_ADMIN" do
    expect(admin_value.type).to eq "HS_ADMIN"
  end

  it "#as_json returns hash" do
    expect(admin_value.as_json).to eq({format: "admin", value: {index: index.to_i, permissions: permissions.to_s, handle: handle.to_s}})
  end

  it "#self.from_s return instance" do
    expect(described_class.from_s("#{index}:#{permissions}:#{handle}")).to eq admin_value
  end

  it "#self.from_h return instance" do
    expect(described_class.from_h("admin", {"index" => index.to_s, "permissions" => permissions.to_s, "handle" => handle.to_s})).to eq admin_value
  end

  it "#self.from_h raises exception on wrong type" do
    expect { described_class.from_h("Admin", {"index" => index.to_s, "permissions" => permissions.to_s, "handle" => handle.to_s}) }.to raise_exception(RuntimeError, "AdminValue unexpected format 'Admin'")
  end
end
