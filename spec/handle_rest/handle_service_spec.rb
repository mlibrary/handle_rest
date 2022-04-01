require "handle_rest"

describe HandleRest::HandleService do
  let(:service) { described_class.new(url: "url", user: "user", password: "password", ssl_verify: false) }
  let(:conn) { instance_double(Faraday::Connection, "conn") }
  let(:response) { instance_double(Faraday::Response, "response", success?: true) }
  let(:id) { HandleRest::Identifier.from_s("PREFIX/HANDLE") }
  let(:value_lines) { [] }

  before { allow(Faraday).to receive(:new).with(url: "url", ssl: {verify: false}).and_return conn }

  describe "#count" do
    let(:prefix) { "PREFIX" }

    before { allow(conn).to receive(:get).with(params: {prefix: prefix, page: 0, pageSize: 0}).and_return response }

    it "returns an empty array" do
      expect(service.count("PREFIX")).to eq 0
    end
  end

  describe "#index" do
    let(:prefix) { "PREFIX" }

    before { allow(conn).to receive(:get).with(params: {prefix: prefix, page: 0, pageSize: 10}).and_return response }

    it "returns an empty array" do
      expect(service.index("PREFIX")).to be_empty
    end
  end

  describe "#get" do
    before { allow(conn).to receive(:get).with(id.to_s).and_return response }

    it "returns an empty array" do
      expect(service.get(id)).to be_empty
    end
  end

  describe "#put" do
    before { allow(conn).to receive(:put).with(id.to_s, value_lines).and_return response }

    it "returns true" do
      expect(service.put(id, value_lines)).to be true
    end
  end

  describe "#delete" do
    before { allow(conn).to receive(:delete).with(id.to_s).and_return response }

    it "returns true" do
      expect(service.delete(id)).to be true
    end
  end
end
