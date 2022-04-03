require "handle_rest"

describe HandleRest::UrlService do
  subject(:url_service) { described_class.new(handle_service) }

  let(:handle_service) { instance_double(HandleRest::HandleService, "handle_service") }
  let(:valid_handle_service) { true }
  let(:handle) { "prefix/suffix" }
  let(:url) { "https://www.umich.edu" }
  let(:new_handle) { "suffix/prefix" }
  let(:new_url) { "https://www.wolverine.net" }

  before do
    allow(handle_service).to receive(:is_a?).with(HandleRest::HandleService).and_return valid_handle_service
  end

  describe "#initialize" do
    it { expect { url_service }.not_to raise_exception }

    context "when not a HandleService" do
      let(:valid_handle_service) { false }

      it { expect { url_service }.to raise_exception(RuntimeError, "not and instance of HandleService") }
    end
  end

  describe "#get" do
    let(:value_lines) { [value_line] }
    let(:value_line) { HandleRest::ValueLine.new(index, value) }
    let(:index) { 1 }
    let(:value) { HandleRest::UrlValue.from_s(url) }

    before do
      allow(handle_service).to receive(:get).with(HandleRest::Handle.from_s(handle)).and_return value_lines
      allow(handle_service).to receive(:get).with(HandleRest::Handle.from_s(new_handle)).and_return []
    end

    context "when handle exist" do
      it { expect(url_service.get(handle)).to eq url }
    end

    context "when handle does not exist" do
      it { expect(url_service.get(new_handle)).to be_nil }
    end
  end

  describe "#set" do
    context "when handle exist" do
      it { expect(url_service.set(handle, new_url)).to eq new_url }
    end

    context "when handle does not exist" do
      it { expect(url_service.set(new_handle, new_url)).to eq new_url }
    end
  end
end
