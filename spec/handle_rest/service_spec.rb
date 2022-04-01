require "handle_rest"

# rubocop:disable RSpec/NestedGroups
describe HandleRest::Service do
  let(:service) { described_class.new(handle_service_rest_url, naming_authority_identifier, admin_identity, admin_password, root_naming_authority_identifier, root_admin_identity, root_admin_password, ssl_verify) }
  let(:handle_service_rest_url) { "url" }
  let(:naming_authority_identifier) { HandleRest::Handle.from_s("0.NA/NAME") }
  let(:admin_identity) { HandleRest::Identity.from_s("300:NAME/ADMIN") }
  let(:admin_password) { "password" }
  let(:root_naming_authority_identifier) { HandleRest::Handle.from_s("0.NA/NAME") }
  let(:root_admin_identity) { HandleRest::Identity.from_s("300:NAME/ADMIN") }
  let(:root_admin_password) { "root_password" }
  let(:ssl_verify) { true }

  describe "#initialize" do
    context "when non-url handle service rest url" do
      let(:handle_service_rest_url) {}

      it { expect { service }.to raise_exception(RuntimeError, "non-url: handle service rest url") }
    end

    context "when non-handle naming authority handle" do
      let(:naming_authority_identifier) {}

      it { expect { service }.to raise_exception(RuntimeError, "non-handle: naming authority handle") }
    end

    context "when non-identity admin identity" do
      let(:admin_identity) {}

      it { expect { service }.to raise_exception(RuntimeError, "non-identity: admin identity") }
    end

    context "when non-handle root naming authority handle" do
      let(:root_naming_authority_identifier) {}

      it { expect { service }.to raise_exception(RuntimeError, "non-handle: root naming authority handle") }
    end

    context "when non-identity root admin identity" do
      let(:root_admin_identity) {}

      it { expect { service }.to raise_exception(RuntimeError, "non-identity: root admin identity") }
    end

    context "when non-boolean ssl verify" do
      let(:ssl_verify) {}

      it { expect { service }.to raise_exception(RuntimeError, "non-boolean: ssl verify") }
    end
  end

  context "with handle service" do
    let(:handle_service) { instance_double(HandleRest::HandleService, "handle_service") }
    let(:handle_identifier) { HandleRest::Handle.from_s("NAME/HANDLE") }
    let(:handle_url) { "URL" }
    let(:value_lines) { [root_admin_value_line, admin_value_line, url_value_line] }
    let(:root_admin_value_line) { HandleRest::ValueLine.new(100, HandleRest::AdminValue.new(root_admin_identity.index, HandleRest::AdminPermissionSet.from_s("111111111111"), root_admin_identity.handle)) }
    let(:admin_value_line) { HandleRest::ValueLine.new(101, HandleRest::AdminValue.new(admin_identity.index, HandleRest::AdminPermissionSet.from_s("110011110001"), admin_identity.handle)) }
    let(:url_value_line) { HandleRest::ValueLine.new(1, HandleRest::UrlValue.new(handle_url)) }

    before do
      allow(HandleRest::HandleService).to receive(:new).and_return handle_service
    end

    describe "#get_url" do
      before do
        allow(handle_service).to receive(:get).with(handle_identifier).and_return value_lines
      end

      context "when non-handle handle" do
        let(:handle_identifier) {}

        it "raises exception" do
          expect { service.get_url(handle_identifier) }.to raise_exception(RuntimeError, "non-handle: handle")
        end
      end

      context "when handle does not exist" do
        let(:value_lines) { [] }

        it "calls handle service get on handle" do
          service.get_url(handle_identifier)
          expect(handle_service).to have_received(:get).with(handle_identifier)
        end

        it "returns nil" do
          expect(service.get_url(handle_identifier)).to be_nil
        end
      end

      context "when handle exist" do
        it "calls handle service get on handle" do
          service.get_url(handle_identifier)
          expect(handle_service).to have_received(:get).with(handle_identifier)
        end

        it "returns url" do
          expect(service.get_url(handle_identifier)).to eq handle_url
        end
      end
    end

    describe "#set_url" do
      before do
        allow(handle_service).to receive(:put).with(handle_identifier, value_lines)
      end

      context "when non-handle handle" do
        let(:handle_identifier) {}

        it "raises exception" do
          expect { service.set_url(handle_identifier, handle_url) }.to raise_exception(RuntimeError, "non-handle: handle")
        end
      end

      context "when non-url handle url" do
        let(:handle_url) {}

        it "raises exception" do
          expect { service.set_url(handle_identifier, handle_url) }.to raise_exception(RuntimeError, "non-url: handle url")
        end
      end

      it "calls handle service put on handle" do
        service.set_url(handle_identifier, handle_url)
        expect(handle_service).to have_received(:put).with(handle_identifier, value_lines)
      end

      it "returns the handle url" do
        expect(service.set_url(handle_identifier, handle_url)).to eq handle_url
      end
    end

    describe "#delete" do
      before do
        allow(handle_service).to receive(:delete).with(handle_identifier).and_return true
      end

      context "when non-handle handle" do
        let(:handle_identifier) {}

        it { expect { service.delete(handle_identifier) }.to raise_exception(RuntimeError, "non-handle: handle") }
      end

      it "calls handle service delete on handle" do
        service.delete(handle_identifier)
        expect(handle_service).to have_received(:delete).with(handle_identifier)
      end

      it "returns nil" do
        expect(service.delete(handle_identifier)).to be_nil
      end
    end
  end
end
# rubocop:enable RSpec/MultipleMemoizedHelpers, RSpec/NestedGroups
