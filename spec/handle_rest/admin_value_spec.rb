require "handle_rest"

describe HandleRest::AdminValue do
  let(:admin_value) { described_class.new(index, permission_set, handle) }
  let(:index) { 300 }
  let(:permission_set) { HandleRest::AdminPermissionSet.new }
  let(:handle) { HandleRest::Handle.from_s("PREFIX/ADMIN") }

  it "is derived from value" do
    expect(admin_value).to be_a_kind_of(HandleRest::Value)
  end

  it "type HS_ADMIN" do
    expect(admin_value.type).to eq "HS_ADMIN"
  end
end
