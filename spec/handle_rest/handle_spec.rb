require "handle_rest"

describe HandleRest::Handle do
  let(:handle) { described_class.new(identifier, handle_service) }
  let(:identifier) { HandleRest::Identifier.from_s("PREFIX/SUFFIX") }
  let(:handle_service) { HandleRest::HandleService.new(url: "", user: "", password: "", ssl_verify: false) }

  describe "#initialize" do
    it "raises exception on non-identifier" do
      expect { described_class.new(nil, nil) }.to raise_exception(RuntimeError, "non-identifier")
    end

    it "raises exception on non-handle service" do
      expect { described_class.new(identifier, nil) }.to raise_exception(RuntimeError, "non-handle service")
    end

    it "does NOT raises exception on valid arguments" do
      expect { described_class.new(identifier, handle_service) }.not_to raise_exception
    end
  end

  describe "#create" do
    let(:admin_value_line) { HandleRest::ValueLine.new(line_index, line_value) }
    let(:line_index) { 100 }
    let(:line_value) { HandleRest::AdminValue.new(admin_index, admin_permission_set, admin_identifier) }
    let(:admin_index) { 300 }
    let(:admin_permission_set) { HandleRest::AdminPermissionSet.new }
    let(:admin_identifier) { HandleRest::Identifier.from_s("PREFIX/ADMIN") }

    before do
      allow(handle_service).to receive(:create).with(handle).and_return(true)
    end

    it "raise exception on non-admin value line" do
      expect { handle.create(HandleRest::ValueLine.new(1, HandleRest::UrlValue.new("url"))) }.to raise_exception(RuntimeError, "non-admin value line")
    end

    it "return true on success" do
      expect(handle.create(admin_value_line)).to be true
    end

    context "when failure" do
      before { allow(handle_service).to receive(:create).with(handle).and_return(false) }

      it "returns false" do
        expect(handle.create(admin_value_line)).to be false
      end
    end
  end
end
