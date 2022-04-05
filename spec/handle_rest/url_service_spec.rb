require "handle_rest"

describe HandleRest::UrlService do
  subject(:url_service) { described_class.new(service_index, service) }

  let(:service_index) { 1 }
  let(:service) { instance_double(HandleRest::Service, "service") }
  let(:handle) { "prefix/suffix" }
  let(:value_lines) { [admin_value_line, url_value_line] }
  let(:admin_value_line) { HandleRest::ValueLine.new(admin_index, admin_value) }
  let(:admin_index) { service_index + 1 }
  let(:admin_value) { HandleRest::AdminValue.new(admin_index, HandleRest::AdminPermissionSet.from_s("000000000000"), HandleRest::Handle.from_s("prefix/admin")) }
  let(:url_value_line) { HandleRest::ValueLine.new(url_index, url_value) }
  let(:url_index) { service_index }
  let(:url_value) { HandleRest::UrlValue.from_s(url) }
  let(:url) { "https://www.urlservice.com" }
  let(:new_value_lines) { [admin_value_line, new_url_value_line] }
  let(:new_url_value_line) { HandleRest::ValueLine.new(url_index, new_url_value) }
  let(:new_url_value) { HandleRest::UrlValue.from_s(new_url) }
  let(:new_url) { url.sub("com", "net") }
  let(:corrupted_url) { new_url.sub("www", "corrupted") }

  before do
    allow(service).to receive(:is_a?).with(HandleRest::Service).and_return true
    allow(service).to receive(:read).with(HandleRest::Handle.from_s(handle)).and_return value_lines
    allow(service).to receive(:write).with(HandleRest::Handle.from_s(handle), HandleRest::UrlValue.from_s(new_url)).and_return new_value_lines
  end

  describe "#initialize" do
    # return url_service
    it { expect { url_service }.not_to raise_exception }

    # raise RuntimeError if 'index' is not an Integer greater than zero, otherwise
    context "when service index nil" do
      subject(:url_service) { described_class.new(nil, service) }

      it { expect { url_service }.to raise_exception(RuntimeError, "Parameter 'index' is not an Integer greater than zero.") }
    end

    context "when service index < 1" do
      subject(:url_service) { described_class.new(0, service) }

      it { expect { url_service }.to raise_exception(RuntimeError, "Parameter 'index' is not an Integer greater than zero.") }
    end

    # raise RuntimeError if 'service' is not an instance of Service, otherwise
    context "when handle service nil" do
      subject(:url_service) { described_class.new(service_index, nil) }

      it { expect { url_service }.to raise_exception(RuntimeError, "Parameter 'service' is not an instance of Service.") }
    end

    context "when handle service not a HandleService" do
      before { allow(service).to receive(:is_a?).with(HandleRest::Service).and_return false }

      it { expect { url_service }.to raise_exception(RuntimeError, "Parameter 'service' is not an instance of Service.") }
    end
  end

  describe "#get" do
    subject(:url_service_get) { url_service.get(handle) }

    # return 'url' of 'index' value line.
    it { expect(url_service_get).to eq url }

    # raise RuntimeError if 'handle' is invalid, index:prefix/suffix, otherwise
    context "when handle nil" do
      subject(:url_service_get) { url_service.get(nil) }

      it { expect { url_service_get }.to raise_exception(RuntimeError, "Handle string '' invalid.") }
    end

    context "when handle invalid" do
      subject(:url_service_get) { url_service.get("handle") }

      it { expect { url_service_get }.to raise_exception(RuntimeError, "Handle string 'handle' invalid.") }
    end

    # return nil if 'handle' does NOT exist, otherwise
    context "when handle does not exist" do
      let(:value_lines) { [] }

      it { expect(url_service_get).to be_nil }
    end

    # return nil if value line at 'index' does NOT exist, otherwise
    context "when handle does not have an 'URL'" do
      let(:value_lines) { [admin_value_line] }

      it { expect(url_service_get).to be_nil }
    end

    # raise RuntimeError if value line at 'index' is NOT an 'URL', otherwise
    context "when handle value at 'service index' is NOT an 'URL'" do
      let(:admin_index) { service_index }
      let(:url_index) { service_index + 1 }

      it { expect { url_service_get }.to raise_exception(RuntimeError, "Value type '#{admin_value.type}' at index '#{admin_value.index}' is NOT an '#{url_value.type}' type.") }
    end

    # Make double sure that it only returns the 'URL' at 'service_index'!
    context "when handle has 'URL' value but not at 'service_idnex;" do
      let(:admin_index) { service_index + 1 }
      let(:url_index) { service_index + 2 }

      it { expect(url_service_get).to be_nil }
    end

    # raise RuntimeError if get of 'url' value line at 'index' fails, otherwise
    context "when service read fails" do
      before { allow(service).to receive(:read).with(HandleRest::Handle.from_s(handle)).and_raise RuntimeError }

      it { expect { url_service_get }.to raise_exception RuntimeError }
    end
  end

  describe "#set" do
    subject(:url_service_set) { url_service.set(handle, new_url) }

    # return 'url' of 'index' value line.
    it { expect(url_service_set).to eq new_url }

    # raise RuntimeError if 'handle' is invalid, index:prefix/suffix, otherwise
    context "when handle invalid" do
      let(:invalid_handle) { "prefix/" }

      it { expect { url_service.set(invalid_handle, new_url) }.to raise_exception(RuntimeError, "Handle string '#{invalid_handle}' invalid.") }
    end

    # raise RuntimeError if 'url' is invalid, scheme/protocol://host name[:port number] [/path][/query_string][/#fragment], otherwise
    context "when url invalid" do
      let(:invalid_url) { "u r l" }

      it { expect { url_service.set(handle, invalid_url) }.to raise_exception(URI::InvalidURIError, "bad URI(is not URI?): \"#{invalid_url}\"") }
    end

    context "when handle does NOT exist" do
      let(:value_lines) { [] }

      before { allow(service).to receive(:create).with(HandleRest::Handle.from_s(handle)).and_return [admin_value_line] }

      it { expect(url_service_set).to eq new_url }

      context "when failed to create handle" do
        before { allow(service).to receive(:create).with(HandleRest::Handle.from_s(handle)).and_return [] }

        it { expect { url_service_set }.to raise_exception(RuntimeError, "Failed to create handle 'prefix/suffix.'") }
      end
    end

    # raise RuntimeError if value line at 'index' is NOT an 'URL', otherwise
    context "when handle value at 'service index' is NOT an 'URL'" do
      let(:admin_index) { service_index }
      let(:url_index) { service_index + 1 }

      it { expect { url_service_set }.to raise_exception(RuntimeError, "Value type '#{admin_value.type}' at index '#{admin_value.index}' is NOT an '#{url_value.type}' type.") }
    end

    # raise RuntimeError if set of 'url' to value line at 'index' fails, otherwise
    describe "service write failures" do
      context "when adding new url fails" do
        let(:value_lines) { [admin_value_line] }
        let(:new_value_lines) { [admin_value_line] }

        it { expect { url_service_set }.to raise_exception(RuntimeError, "Failed to add url '#{new_url}' to '#{handle}' at index '#{service_index}'.") }
      end

      context "when failure deletes url" do
        let(:new_value_lines) { [] }

        it { expect { url_service_set }.to raise_exception(RuntimeError, "Failure deleted url '#{url}' from '#{handle}' at index '#{service_index}'!!!") }
      end

      context "when replacing old url fails" do
        let(:new_value_lines) { value_lines }

        it { expect { url_service_set }.to raise_exception(RuntimeError, "Failed to replace url '#{url}' with '#{new_url}' for '#{handle}' at index '#{service_index}'.") }
      end

      context "when failure corrupts url" do
        let(:new_url_value) { HandleRest::UrlValue.from_s(corrupted_url) }

        it { expect { url_service_set }.to raise_exception(RuntimeError, "Failure corrupted url '#{url}' with '#{corrupted_url}' for '#{handle}' at index '#{service_index}'!!!") }
      end

      context "when service write fails" do
        before { allow(service).to receive(:write).with(HandleRest::Handle.from_s(handle), HandleRest::UrlValue.from_s(new_url)).and_raise RuntimeError }

        it { expect { url_service_set }.to raise_exception RuntimeError }
      end
    end
  end
end
