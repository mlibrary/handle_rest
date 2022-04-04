require "handle_rest"

describe HandleRest::Service do
  subject(:service) { described_class.new(value_lines, handle_service) }

  let(:value_lines) { [admin_value_line] }
  let(:admin_value_line) { HandleRest::ValueLine.new(admin_index, admin_value) }
  let(:admin_index) { 300 }
  let(:admin_value) { HandleRest::AdminValue.new(admin_index, HandleRest::AdminPermissionSet.from_s("000000000000"), HandleRest::Handle.from_s("prefix/admin")) }
  let(:handle_service) { instance_double(HandleRest::HandleService, "handle_service") }
  let(:is_a_handle_service) { true }

  before do
    allow(handle_service).to receive(:is_a?).with(HandleRest::HandleService).and_return is_a_handle_service
  end

  describe "#initialize" do
    it { expect { service }.not_to raise_exception }
  end

  # let(:service) { described_class.new(handle_service_rest_url, naming_authority_identifier, admin_identity, admin_password, root_naming_authority_identifier, root_admin_identity, root_admin_password, ssl_verify) }
  # let(:handle_service_rest_url) { "url" }
  # let(:naming_authority_identifier) { HandleRest::Handle.from_s("0.NA/NAME") }
  # let(:admin_identity) { HandleRest::Identity.from_s("300:NAME/ADMIN") }
  # let(:admin_password) { "password" }
  # let(:root_naming_authority_identifier) { HandleRest::Handle.from_s("0.NA/NAME") }
  # let(:root_admin_identity) { HandleRest::Identity.from_s("300:NAME/ADMIN") }
  # let(:root_admin_password) { "root_password" }
  # let(:ssl_verify) { true }
  #
  # describe "#initialize" do
  #   context "when non-url handle service rest url" do
  #     let(:handle_service_rest_url) {}
  #
  #     it { expect { service }.to raise_exception(RuntimeError, "non-url: handle service rest url") }
  #   end
  #
  #   context "when non-handle naming authority handle" do
  #     let(:naming_authority_identifier) {}
  #
  #     it { expect { service }.to raise_exception(RuntimeError, "non-handle: naming authority handle") }
  #   end
  #
  #   context "when non-identity admin identity" do
  #     let(:admin_identity) {}
  #
  #     it { expect { service }.to raise_exception(RuntimeError, "non-identity: admin identity") }
  #   end
  #
  #   context "when non-handle root naming authority handle" do
  #     let(:root_naming_authority_identifier) {}
  #
  #     it { expect { service }.to raise_exception(RuntimeError, "non-handle: root naming authority handle") }
  #   end
  #
  #   context "when non-identity root admin identity" do
  #     let(:root_admin_identity) {}
  #
  #     it { expect { service }.to raise_exception(RuntimeError, "non-identity: root admin identity") }
  #   end
  #
  #   context "when non-boolean ssl verify" do
  #     let(:ssl_verify) {}
  #
  #     it { expect { service }.to raise_exception(RuntimeError, "non-boolean: ssl verify") }
  #   end
  # end
  #
  # context "with handle service" do
  #   let(:handle_service) { instance_double(HandleRest::HandleService, "handle_service") }
  #   let(:handle) { HandleRest::Handle.from_s("NAME/HANDLE") }
  #   let(:url) { "URL" }
  #   let(:value_lines) { [root_admin_value_line, admin_value_line, url_value_line] }
  #   let(:root_admin_value_line) { HandleRest::ValueLine.new(100, HandleRest::AdminValue.new(root_admin_identity.index, HandleRest::AdminPermissionSet.from_s("111111111111"), root_admin_identity.handle)) }
  #   let(:admin_value_line) { HandleRest::ValueLine.new(101, HandleRest::AdminValue.new(admin_identity.index, HandleRest::AdminPermissionSet.from_s("110011110001"), admin_identity.handle)) }
  #   let(:url_value_line) { HandleRest::ValueLine.new(1, HandleRest::UrlValue.new(url)) }
  #
  #   before do
  #     allow(HandleRest::HandleService).to receive(:new).and_return handle_service
  #   end
  #
  #   describe "#create" do
  #     before do
  #       allow(handle_service).to receive(:put).with(handle).and_return true
  #     end
  #   end
  #
  #   describe "#delete" do
  #     before do
  #       allow(handle_service).to receive(:delete).with(handle).and_return true
  #     end
  #
  #     context "when non-handle handle" do
  #       let(:handle) {}
  #
  #       it { expect { service.delete(handle) }.to raise_exception(RuntimeError, "non-handle: handle") }
  #     end
  #
  #     it "calls handle service delete on handle" do
  #       service.delete(handle)
  #       expect(handle_service).to have_received(:delete).with(handle)
  #     end
  #
  #     it "returns handle" do
  #       expect(service.delete(handle)).to eq handle
  #     end
  #   end
  # end
end
