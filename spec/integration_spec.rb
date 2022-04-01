require "handle_rest"

PREFIX = ENV["HS_PREFIX"]
REST_URL = ENV["HS_REST_URL"]
USER = ENV["HS_USER"]
PASSWORD = ENV["HS_PASSWORD"]
SSL_VERIFY = !(ENV["HS_SSL_VERIFY"] == "0")

describe "INTEGRATION" do
  # root
  let(:root_id) { HandleRest::Identity.from_s(USER) }
  let(:root_ps) {
    HandleRest::AdminPermissionSet.new(
      add_handle: true,
      delete_handle: true,
      add_naming_authority: true,
      delete_naming_authority: true,
      modify_values: true,
      remove_values: true,
      add_values: true,
      read_values: true,
      modify_administrator: true,
      remove_administrator: true,
      add_administrator: true,
      list_handles: true
    )
  }
  let(:root_hs) { HandleRest::HandleService.new(url: REST_URL, user: root_id.to_s, password: PASSWORD, ssl_verify: false) }
  # admin
  let(:admin_id) { HandleRest::Identity.from_s("300:#{PREFIX}/ADMIN") }
  let(:admin_ps) {
    HandleRest::AdminPermissionSet.new(
      add_handle: true,
      delete_handle: true,
      add_naming_authority: true,
      delete_naming_authority: true,
      modify_values: true,
      remove_values: true,
      add_values: true,
      read_values: true,
      modify_administrator: true,
      remove_administrator: true,
      add_administrator: true,
      list_handles: true
    )
  }
  let(:admin_hs) { HandleRest::HandleService.new(url: REST_URL, user: admin_id.to_s, password: PASSWORD, ssl_verify: false) }
  # HS_ADMIN: 100, 101
  let(:root_admin_value_line) { HandleRest::ValueLine.new(100, HandleRest::AdminValue.new(200, root_ps, root_id.handle)) }
  let(:admin_admin_value_line) { HandleRest::ValueLine.new(101, HandleRest::AdminValue.new(201, admin_ps, root_id.handle)) }
  # HS_VLIST: 200, 201
  let(:root_reference_list_value_line) { HandleRest::ValueLine.new(200, HandleRest::ReferenceListValue.new([root_id])) }
  let(:admin_reference_list_value_line) { HandleRest::ValueLine.new(201, HandleRest::ReferenceListValue.new([admin_id])) }
  # HS_SECKEY: 300, 300
  let(:root_secret_key_value_line) { HandleRest::ValueLine.new(root_id.index, HandleRest::SecretKeyValue.new(PASSWORD)) }
  let(:admin_secret_key_value_line) { HandleRest::ValueLine.new(admin_id.index, HandleRest::SecretKeyValue.new(PASSWORD)) }

  before do
    unless ENV["INTEGRATION"] == "1"
      skip "Integration test env vars not set, see README.md"
    end
    # PREFIX/PREFIX
    # 100 HS_ADMIN 200:111111111111:PREFIX/PREFIX
    # 101 HS_ADMIN 201:111111111111:PREFIX/PREFIX
    # 200 HS_VLIST 300:PREFIX/PREFIX
    # 201 HS_VLIST 300:PREFIX/ADMIN
    # 300 HS_SECKEY PASSWORD
    root_hs.put(root_id.handle, [root_admin_value_line, admin_admin_value_line, root_reference_list_value_line, admin_reference_list_value_line, root_secret_key_value_line])
    # PREFIX/ADMIN
    # 100 HS_ADMIN 200:111111111111:PREFIX/PREFIX
    # 300 HS_SECKEY PASSWORD
    root_hs.put(admin_id.handle, [root_admin_value_line, admin_secret_key_value_line])
  end

  after do
    unless ENV["INTEGRATION"] == "1"
      skip "Integration test env vars not set, see README.md"
    end
    root_hs.index(PREFIX).each do |handle|
      next if handle == root_id.handle
      root_hs.delete(handle)
    end
  end

  context "when before context" do
    it "has two handles" do
      expect(root_hs.index(PREFIX)).to contain_exactly(root_id.handle, admin_id.handle)
    end

    it "root handle has expected value lines" do
      expect(root_hs.get(root_id.handle)).to contain_exactly(root_admin_value_line, admin_admin_value_line, root_reference_list_value_line, admin_reference_list_value_line, root_secret_key_value_line)
    end

    it "admin handle has expected value lines" do
      expect(root_hs.get(admin_id.handle)).to contain_exactly(root_admin_value_line, admin_secret_key_value_line)
    end
  end

  context "when url handle" do
    # handle
    let(:handle) { HandleRest::Handle.from_s("#{PREFIX}/HANDLE") }
    # URL: 1, 1
    let(:handle_url_value_line) { HandleRest::ValueLine.new(1, HandleRest::UrlValue.new(handle_url)) }
    let(:handle_new_url_value_line) { HandleRest::ValueLine.new(1, HandleRest::UrlValue.new(handle_new_url)) }
    let(:handle_url) { "https://www.wolverine.com" }
    let(:handle_new_url) { "https://www.michigan.com" }

    # PREFIX/HANDLE
    # 100 HS_ADMIN 200:111111111111:PREFIX/PREFIX
    # 101 HS_ADMIN 201:111111111111:PREFIX/PREFIX
    # 1 URL <handle_url or new_handle_url>
    before { root_hs.put(handle, [root_admin_value_line, admin_admin_value_line, handle_url_value_line]) }

    it "created the handle with expected values" do
      expect(admin_hs.get(handle)).to contain_exactly(root_admin_value_line, admin_admin_value_line, handle_url_value_line)
    end

    context "when updating the url value" do
      before { admin_hs.put(handle, [handle_new_url_value_line], true) }

      it "updated the handle with expected value" do
        expect(admin_hs.get(handle)).to contain_exactly(root_admin_value_line, admin_admin_value_line, handle_new_url_value_line)
      end
    end

    context "when deleting the handle" do
      before { admin_hs.delete(handle) }

      it "delete the handle" do
        expect { admin_hs.get(handle) }.to raise_exception(RuntimeError, "#{handle} - 100: Handle Not Found")
      end
    end
  end
end
# rubocop:enable RSpec/MultipleMemoizedHelpers
