require "handle_rest"

PREFIX = ENV["HS_PREFIX"]
REST_URL = ENV["HS_REST_URL"]
USER = ENV["HS_USER"]
PASSWORD = ENV["HS_PASSWORD"]
SSL_VERIFY = !(ENV["HS_SSL_VERIFY"] == "0")

describe "INTEGRATION" do
  let(:root_admin) { HandleRest::Identity.from_s(USER) }
  let(:root_admin_ps) { HandleRest::AdminPermissionSet.new }
  let(:root_hs) { HandleRest::HandleService.new(url: REST_URL, user: root_admin.to_s, password: PASSWORD, ssl_verify: SSL_VERIFY) }
  let(:admin) { HandleRest::Identity.from_s("300:#{PREFIX}/ADMIN") }
  let(:admin_ps) {
    HandleRest::AdminPermissionSet.new(
      add_naming_authority: false,
      delete_naming_authority: false,
      modify_administrator: false,
      remove_administrator: false,
      add_administrator: false
    )
  }
  let(:hs) { HandleRest::HandleService.new(url: REST_URL, user: admin.to_s, password: PASSWORD, ssl_verify: SSL_VERIFY) }
  let(:root_admin_value_line) { HandleRest::ValueLine.new(100, HandleRest::AdminValue.new(root_admin.index, root_admin_ps, root_admin.identifier)) }
  let(:admin_value_line) { HandleRest::ValueLine.new(101, HandleRest::AdminValue.new(admin.index, admin_ps, admin.identifier)) }
  let(:secret_key_value_line) { HandleRest::ValueLine.new(300, HandleRest::SecretKeyValue.new(PASSWORD)) }

  before do
    unless ENV["INTEGRATION"] == 1
      skip "Integration test env vars not set, see README.md"
    end
    root_hs.put(admin.identifier, [root_admin_value_line, admin_value_line, secret_key_value_line])
  end

  after do
    unless ENV["INTEGRATION"] == 1
      skip "Integration test env vars not set, see README.md"
    end
    root_hs.index(PREFIX).each do |identifier|
      next if identifier == root_admin.identifier
      root_hs.delete(identifier)
    end
  end

  context "when before context" do
    it "has two handles" do
      expect(root_hs.index(PREFIX)).to contain_exactly(root_admin.identifier, admin.identifier)
    end

    it "has root admin handle with expected value lines" do
      expect(root_hs.get(root_admin.identifier)).to contain_exactly(root_admin_value_line, secret_key_value_line)
    end

    it "has admin handle with expected value lines" do
      expect(root_hs.get(admin.identifier)).to contain_exactly(root_admin_value_line, admin_value_line, secret_key_value_line)
    end
  end

  context "when url handle" do
    let(:handle_id) { HandleRest::Handle.from_s("#{PREFIX}/HANDLE_WITH_URL_VALUE") }
    let(:url_value_line) { HandleRest::ValueLine.new(1, HandleRest::UrlValue.new(handle_url)) }
    let(:handle_url) { "https://www.wolverine.com" }
    let(:new_url_value_line) { HandleRest::ValueLine.new(1, HandleRest::UrlValue.new(new_handle_url)) }
    let(:new_handle_url) { "https://www.michigan.com" }

    before { hs.put(handle_id, [root_admin_value_line, admin_value_line, url_value_line]) }

    it "created the handle with expected values" do
      expect(hs.get(handle_id)).to contain_exactly(root_admin_value_line, admin_value_line, url_value_line)
    end

    context "when updating the url value" do
      before { hs.put(handle_id, [new_url_value_line], true) }

      it "updated the handle with expected value" do
        expect(hs.get(handle_id)).to contain_exactly(root_admin_value_line, admin_value_line, new_url_value_line)
      end
    end

    context "when deleting the handle" do
      before { hs.delete(handle_id) }

      it "delete the handle" do
        expect { hs.get(handle_id) }.to raise_exception(RuntimeError, "GREG")
      end
    end
  end
end
# rubocop:enable RSpec/MultipleMemoizedHelpers
