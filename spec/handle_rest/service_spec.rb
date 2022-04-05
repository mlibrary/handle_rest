require "handle_rest"

describe HandleRest::Service do
  subject(:service) { described_class.new(service_value_lines, handle_service) }

  let(:service_value_lines) { [admin_value_line] }
  let(:admin_value_line) { HandleRest::ValueLine.new(admin_index, admin_value) }
  let(:admin_index) { 100 }
  let(:admin_value) { HandleRest::AdminValue.new(300, HandleRest::AdminPermissionSet.from_s("000000000000"), HandleRest::Handle.from_s("prefix/admin")) }
  let(:handle_service) { instance_double(HandleRest::HandleService, "handle_service") }
  let(:handle) { HandleRest::Handle.from_s("prefix/suffix") }
  let(:url_value_line) { HandleRest::ValueLine.new(url_index, url_value) }
  let(:url_index) { 1 }
  let(:url_value) { HandleRest::UrlValue.from_s(url) }
  let(:url) { "https://www.service.com" }
  let(:value_lines) { [admin_value_line, url_value_line] }
  let(:next_value_lines) { service_value_lines }
  let(:email_value_line) { HandleRest::ValueLine.new(email_index, email_value) }
  let(:email_index) { 2 }
  let(:email_value) { HandleRest::EmailValue.from_s(email) }
  let(:email) { "wolverine@umich.edu" }
  let(:put_value_lines) { [] }
  let(:indices) { [] }

  before do
    allow(handle_service).to receive(:is_a?).with(HandleRest::HandleService).and_return true
    allow(handle_service).to receive(:get).with(handle).and_return value_lines, next_value_lines
    allow(handle_service).to receive(:post).with(handle, service_value_lines).and_return true
    allow(handle_service).to receive(:delete).with(handle).and_return true
    allow(handle_service).to receive(:put).with(handle, put_value_lines).and_return true
    allow(handle_service).to receive(:delete).with(handle, indices).and_return true
  end

  describe "#initialize" do
    # return service
    it { expect { service }.not_to raise_exception }

    # raise RuntimeError if 'service_value_lines' does NOT have at least one AdminValueLine, otherwise
    context "when value lines nil" do
      let(:service_value_lines) { nil }

      it { expect { service }.to raise_exception(RuntimeError, "Parameter 'value_lines' must be an Array<ValueLine> with at least one AdminValue.") }
    end

    context "when value lines empty" do
      let(:service_value_lines) { [] }

      it { expect { service }.to raise_exception(RuntimeError, "Parameter 'value_lines' must be an Array<ValueLine> with at least one AdminValue.") }
    end

    context "when value lines does NOT have an admin value line" do
      let(:service_value_lines) { [url_value_line] }

      it { expect { service }.to raise_exception(RuntimeError, "Parameter 'value_lines' must be an Array<ValueLine> with at least one AdminValue.") }
    end

    # raise RuntimeError if 'handle_service' is not an instance of HandleService, otherwise
    context "when handle service nil" do
      subject(:service) { described_class.new(service_value_lines, nil) }

      it { expect { service }.to raise_exception(RuntimeError, "Parameter 'handle_service' must be an instance of HandleService.") }
    end

    context "when handle service not a HandleService" do
      before { allow(handle_service).to receive(:is_a?).with(HandleRest::HandleService).and_return false }

      it { expect { service }.to raise_exception(RuntimeError, "Parameter 'handle_service' must be an instance of HandleService.") }
    end
  end

  describe "#create" do
    subject(:service_create) { service.create(handle) }

    # return value lines of 'handle' if 'handle' exist, otherwise
    it { expect(service_create).to eq value_lines }

    # raise RuntimeError if 'handle' is invalid, index:prefix/suffix, otherwise
    context "when handle nil" do
      let(:handle) {}

      it { expect { service_create }.to raise_exception(RuntimeError, "Parameter 'handle' must be an instance of Handle.") }
    end

    context "when handle invalid" do
      let(:handle) { "handle" }

      it { expect { service_create }.to raise_exception(RuntimeError, "Parameter 'handle' must be an instance of Handle.") }
    end

    # return value lines of new 'handle' a.k.a. default value lines
    context "when handle does not exist" do
      let(:value_lines) { [] }

      it { expect(service_create).to eq service_value_lines }

      # raise RuntimeError if create new 'handle' fails, otherwise
      context "when create fails" do
        before { allow(handle_service).to receive(:post).with(handle, service_value_lines).and_raise RuntimeError }

        it { expect { service_create }.to raise_exception(RuntimeError) }
      end
    end
  end

  describe "#delete" do
    subject(:service_delete) { service.delete(handle) }

    # return deleted value lines of 'handle'
    it { expect(service_delete).to eq value_lines }

    # raise RuntimeError if 'handle' is invalid, index:prefix/suffix, otherwise
    context "when handle nil" do
      let(:handle) {}

      it { expect { service_delete }.to raise_exception(RuntimeError, "Parameter 'handle' must be an instance of Handle.") }
    end

    context "when handle invalid" do
      let(:handle) { "handle" }

      it { expect { service_delete }.to raise_exception(RuntimeError, "Parameter 'handle' must be an instance of Handle.") }
    end

    # return [] if 'handle' does NOT exist, otherwise
    context "when handle does NOT exist" do
      let(:value_lines) { [] }

      it { expect(service_delete).to be_empty }
    end

    context "when delete handle fails" do
      before { allow(handle_service).to receive(:delete).with(handle).and_raise RuntimeError }

      it { expect { service_delete }.to raise_exception(RuntimeError) }
    end
  end

  describe "#read" do
    subject(:service_read) { service.read(handle) }

    # return value lines of the 'handle'
    it { expect(service_read).to eq value_lines }

    # raise RuntimeError if 'handle' is invalid, index:prefix/suffix, otherwise
    context "when handle nil" do
      let(:handle) {}

      it { expect { service_read }.to raise_exception(RuntimeError, "Parameter 'handle' must be an instance of Handle.") }
    end

    context "when handle invalid" do
      let(:handle) { "handle" }

      it { expect { service_read }.to raise_exception(RuntimeError, "Parameter 'handle' must be an instance of Handle.") }
    end

    # return [] if 'handle' does NOT exist, otherwise
    context "when handle does not exist" do
      let(:value_lines) { [] }

      it { expect(service_read).to eq [] }
    end

    # raise RuntimeError if read 'handle' fails, otherwise
    context "when read handle fails" do
      before { allow(handle_service).to receive(:get).with(handle).and_raise RuntimeError }

      it { expect { service_read }.to raise_exception RuntimeError }
    end
  end

  describe "#write" do
    subject(:service_write) { service.write(handle, put_value_lines) }

    let(:put_value_lines) { [email_value_line] }
    let(:next_value_lines) { [admin_value_line, url_value_line, email_value_line] }

    # return value lines of the 'handle'
    it { expect(service_write).to eq next_value_lines }

    # raise RuntimeError if 'handle' is invalid, index:prefix/suffix, otherwise
    context "when handle nil" do
      let(:handle) {}

      it { expect { service_write }.to raise_exception(RuntimeError, "Parameter 'handle' must be an instance of Handle.") }
    end

    context "when handle invalid" do
      let(:handle) { "handle" }

      it { expect { service_write }.to raise_exception(RuntimeError, "Parameter 'handle' must be an instance of Handle.") }
    end

    context "when value_lines nil" do
      let(:put_value_lines) {}

      it { expect { service_write }.to raise_exception(RuntimeError, "Parameter 'value_lines' must be an Array<ValueLine>.") }
    end

    context "when value_lines non Array<ValueLine>" do
      let(:put_value_lines) { ["handle"] }

      it { expect { service_write }.to raise_exception(RuntimeError, "Parameter 'value_lines' must be an Array<ValueLine>.") }
    end

    # return [] if 'handle' does NOT exist, otherwise
    context "when handle does not exist" do
      let(:value_lines) { [] }
      let(:next_value_lines) { [admin_value_line, email_value_line] }

      it { expect(service_write).to eq next_value_lines }
    end

    # raise RuntimeError if write 'handle' fails, otherwise
    context "when write handle fails" do
      before { allow(handle_service).to receive(:put).with(handle, put_value_lines).and_raise RuntimeError }

      it { expect { service_write }.to raise_exception RuntimeError }
    end
  end

  describe "#remove" do
    subject(:service_remove) { service.remove(handle, indices) }

    let(:indices) { [url_index] }

    # return remaining value lines of 'handle'
    it { expect(service_remove).to eq [admin_value_line] }

    # raise RuntimeError if 'handle' is invalid, index:prefix/suffix, otherwise
    context "when handle nil" do
      let(:handle) {}

      it { expect { service_remove }.to raise_exception(RuntimeError, "Parameter 'handle' must be an instance of Handle.") }
    end

    context "when handle invalid" do
      let(:handle) { "handle" }

      it { expect { service_remove }.to raise_exception(RuntimeError, "Parameter 'handle' must be an instance of Handle.") }
    end

    # raise RuntimeError if 'indices' is not an Array<Integer> of integers > 0, otherwise
    context "when indices nil" do
      let(:indices) {}

      it { expect { service_remove }.to raise_exception(RuntimeError, "Parameter 'indices' must be an Array<Integer> of integers > 0.") }
    end

    context "when indices non integers" do
      let(:indices) { [1.0, 2.0] }

      it { expect { service_remove }.to raise_exception(RuntimeError, "Parameter 'indices' must be an Array<Integer> of integers > 0.") }
    end

    context "when indices < 1" do
      let(:indices) { [0, 1] }

      it { expect { service_remove }.to raise_exception(RuntimeError, "Parameter 'indices' must be an Array<Integer> of integers > 0.") }
    end

    # return [] if 'handle' does NOT exist, otherwise
    context "when handle does NOT exist" do
      let(:value_lines) { [] }

      it { expect(service_remove).to be_empty }
    end

    # raise RuntimeError if remove value lines of 'handle' at 'indices' fails, otherwise
    context "when delete handle indicies fails" do
      before { allow(handle_service).to receive(:delete).with(handle, indices).and_raise RuntimeError }

      it { expect { service_remove }.to raise_exception RuntimeError }
    end
  end
end
