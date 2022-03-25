require "handle_rest"

PREFIX = ENV["HS_PREFIX"] || "9999/"

RSpec.describe HandleService do
  let(:handle) { Handle.new("#{PREFIX}test", url: TEST_URL) }
  let(:service) do
    verify_ssl = true
    verify_ssl = false if ENV["HS_SSL_VERIFY"] == "0"
    described_class.new(url: ENV["HS_REST_URL"] || "https:/localhost:8000/api/handles/",
      user: ENV["HS_USER"] || "300:9999/ADMIN",
      password: ENV["HS_SECKEY"] || "password",
      ssl_verify: verify_ssl)
  end

  before do
    unless ENV["INTEGRATION"]
      skip "Integration test env vars not set, see README.md"
    end
  end

  describe "#get" do
    it "returns nil when not found" do
      returned_handle = service.get("nonexistent")
      expect(returned_handle).to be_nil
    end
  end

  describe "#create" do
    it "returns truthy" do
      expect(service.create(handle)).to be_truthy
    end

    it "throws an exception when unsuccessful" do
      bad_handle = Handle.new("laksjdf/laksjdf", url: "THIS_IS_NOT_A_URL")
      expect { service.create(bad_handle) }.to raise_exception RuntimeError
    end
  end

  context "with a handle" do
    before { service.create(handle) }

    describe "#get" do
      it "gets the handle" do
        returned_handle = service.get(handle.id)
        expect(returned_handle.id).to eq handle.id
        expect(returned_handle.url).to eq handle.url
      end
    end

    describe "#delete" do
      it "returns truthy" do
        expect(service.delete(handle.id)).to be_truthy
      end

      it "actually deletes the handle" do
        service.delete(handle.id)
        expect(service.get(handle.id)).to be_nil
      end
    end
  end
end
