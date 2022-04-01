require "handle_rest"

describe HandleRest::HandleService do
  let(:service) { described_class.new(url: "url", user: "user", password: "password", ssl_verify: false) }
  let(:conn) { instance_double(Faraday::Connection, "conn") }
  let(:response) { instance_double(Faraday::Response, "response", success?: true, body: response_body) }
  let(:response_body) { {} }
  let(:handle) { HandleRest::Handle.from_s("PREFIX/HANDLE") }
  let(:value_lines) { [] }

  before { allow(Faraday).to receive(:new).with(url: "url", ssl: {verify: false}).and_return conn }

  describe "#count" do
    let(:prefix) { "PREFIX" }
    let(:response_body) { {"totalCount" => 0} }

    before { allow(conn).to receive(:get).with("", {prefix: prefix, page: 0, pageSize: 0}).and_return response }

    it "returns an empty array" do
      expect(service.count("PREFIX")).to eq 0
    end
  end

  describe "#index" do
    let(:prefix) { "PREFIX" }
    let(:response_body) { {"handles" => []} }

    before { allow(conn).to receive(:get).with("", {prefix: prefix, page: -1, pageSize: -1}).and_return response }

    it "returns an empty array" do
      expect(service.index("PREFIX")).to be_empty
    end
  end

  describe "#get" do
    let(:response_body) { {"values" => []} }

    before { allow(conn).to receive(:get).with(handle.to_s).and_return response }

    it "returns an empty array" do
      expect(service.get(handle)).to be_empty
    end
  end

  describe "#put" do
    before { allow(conn).to receive(:put).with(handle.to_s, value_lines).and_return response }

    it "returns true" do
      expect(service.put(handle, value_lines)).to be true
    end
  end

  describe "#delete" do
    before { allow(conn).to receive(:delete).with(handle.to_s).and_return response }

    it "returns true" do
      expect(service.delete(handle)).to be true
    end
  end

  describe "#response_code_message" do
    it "maps 1 to" do
      expect(service.send(:response_code_message, 1)).to eq "Success"
    end

    it "maps 2 to" do
      expect(service.send(:response_code_message, 2)).to eq "Error"
    end

    it "maps 3 to" do
      expect(service.send(:response_code_message, 3)).to eq "Server Too Busy"
    end

    it "maps 4 to" do
      expect(service.send(:response_code_message, 4)).to eq "Protocol Error"
    end

    it "maps 5 to" do
      expect(service.send(:response_code_message, 5)).to eq "Operation Not Supported"
    end

    it "maps 6 to" do
      expect(service.send(:response_code_message, 6)).to eq "Recursion Count Too High"
    end

    it "maps 7 to" do
      expect(service.send(:response_code_message, 7)).to eq "Server Read-only"
    end

    it "maps 100 to" do
      expect(service.send(:response_code_message, 100)).to eq "Handle Not Found"
    end

    it "maps 101 to" do
      expect(service.send(:response_code_message, 101)).to eq "Handle Already Exists"
    end

    it "maps 102 to" do
      expect(service.send(:response_code_message, 102)).to eq "Invalid Handle"
    end

    it "maps 200 to" do
      expect(service.send(:response_code_message, 200)).to eq "Values Not Found"
    end

    it "maps 201 to" do
      expect(service.send(:response_code_message, 201)).to eq "Value Already Exists"
    end

    it "maps 202 to" do
      expect(service.send(:response_code_message, 202)).to eq "Invalid Value"
    end

    it "maps 300 to" do
      expect(service.send(:response_code_message, 300)).to eq "Out of Date Site Info"
    end

    it "maps 301 to" do
      expect(service.send(:response_code_message, 301)).to eq "Server Not Responsible"
    end

    it "maps 302 to" do
      expect(service.send(:response_code_message, 302)).to eq "Service Referral"
    end

    it "maps 303 to" do
      expect(service.send(:response_code_message, 303)).to eq "Prefix Referral"
    end

    it "maps 400 to" do
      expect(service.send(:response_code_message, 400)).to eq "Invalid Admin"
    end

    it "maps 401 to" do
      expect(service.send(:response_code_message, 401)).to eq "Insufficient Permissions"
    end

    it "maps 402 to" do
      expect(service.send(:response_code_message, 402)).to eq "Authentication Needed"
    end

    it "maps 403 to" do
      expect(service.send(:response_code_message, 403)).to eq "Authentication Failed"
    end

    it "maps 404 to" do
      expect(service.send(:response_code_message, 404)).to eq "Invalid Credential"
    end

    it "maps 405 to" do
      expect(service.send(:response_code_message, 405)).to eq "Authentication Timed Out"
    end

    it "maps 406 to" do
      expect(service.send(:response_code_message, 406)).to eq "Authentication Error"
    end

    it "maps 500 to" do
      expect(service.send(:response_code_message, 500)).to eq "Session Timeout"
    end

    it "maps 501 to" do
      expect(service.send(:response_code_message, 501)).to eq "Session Failed"
    end

    it "maps 502 to" do
      expect(service.send(:response_code_message, 502)).to eq "Invalid Session Key"
    end

    it "maps 503 to" do
      expect(service.send(:response_code_message, 503)).to eq "Response Code Message Missing!"
    end

    it "maps 504 to" do
      expect(service.send(:response_code_message, 504)).to eq "Invalid Session Setup Request"
    end

    it "maps 505 to" do
      expect(service.send(:response_code_message, 505)).to eq "Session Duplicate Msg Rejected"
    end
  end
end
