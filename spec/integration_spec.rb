require "handle_rest"

PREFIX = ENV["HS_PREFIX"]
REST_URL = ENV["HS_REST_URL"]
USER = ENV["HS_USER"]
PASSWORD = ENV["HS_SECKEY"]
SSL_VERIFY = !(ENV["HS_SSL_VERIFY"] == "0")

describe "INTEGRATION", if: ENV["INTEGRATION"] == "1" do
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
  # let(:admin_ps) {
  #   HandleRest::AdminPermissionSet.new(
  #     add_handle: true,
  #     delete_handle: true,
  #     add_naming_authority: true,
  #     delete_naming_authority: true,
  #     modify_values: true,
  #     remove_values: true,
  #     add_values: true,
  #     read_values: true,
  #     modify_administrator: true,
  #     remove_administrator: true,
  #     add_administrator: true,
  #     list_handles: true
  #   )
  # }
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
    # 101 HS_ADMIN 201:????????????:PREFIX/PREFIX
    # 200 HS_VLIST 300:PREFIX/PREFIX
    # 201 HS_VLIST 300:PREFIX/ADMIN
    # 300 HS_SECKEY PASSWORD
    root_hs.post(root_id.handle, [root_admin_value_line, admin_admin_value_line, root_reference_list_value_line, admin_reference_list_value_line, root_secret_key_value_line])
    # PREFIX/ADMIN
    # 100 HS_ADMIN 200:111111111111:PREFIX/PREFIX
    # 300 HS_SECKEY PASSWORD
    root_hs.post(admin_id.handle, [root_admin_value_line, admin_secret_key_value_line])
  end

  after do
    unless ENV["INTEGRATION"] == "1"
      skip "Integration test env vars not set, see README.md"
    end
    root_hs.index(PREFIX).each do |handle|
      next if handle == root_id.handle
      next if handle == admin_id.handle
      root_hs.delete(handle)
    end
  end

  # https://www.handle.net/tech_manual/HN_Tech_Manual_8.pdf
  #   4.9 Handle Value Line Format
  #
  #   Each handle value line is composed of:
  #     value_index + space + value_type + space + ttl + space + permission_set + space + value_data
  #
  #   The value index is a unique integer within the specific handle. The value types are:
  #     HS_ADMIN, HS_SECKEY, EMAIL, URL, HS_PUBKEY, URN, HS_SERV, HS_VLIST, HS_ALIAS.
  #
  #   ttl:handle's time to live in cache counted by seconds. Default is 86400(24 hours).
  #
  #   Permission set:permission values indicated by 4 characters, '1' is true, '0' is false, order is:
  #       admin read, admin write, public read, public write.
  #
  # Value data:If the handle value data defines an Administrator, its data format is:
  #   ADMIN + space + admin index:admin permission set:admin handle
  #
  # The admin permission set is twelve characters with the following order:
  #   add handle, delete handle, add naming authority, delete naming authority,
  #   modify values, remove values, add values, read values,
  #   modify administrator, remove administrator, add administrator and list handles.
  #
  # If the handle value type is one of HS_SECKEY, HS_SERV, HS_ALIAS, EMAIL, URL, URN, its data will be a
  # string. The value data format is:
  #   UTF8 + space + string_content
  #
  # If the handle value data is a local file, its data format is:
  #   FILE + space + file_path
  #
  # If the handle value data is a value reference list, its data format is:
  #   LIST + space + index1:handle1;index2:handle2;
  #
  # ************************************************************************************************
  # DEV NOTE 1: The above is for batch file processing because the API section only has this to say:
  # ************************************************************************************************
  #
  # 14.8 JSON Representation of Handle Values
  #   Each value is a JSON object with generally 5 attributes:
  #     ● "index" : an integer
  #     ● "type" : a string
  #     ● "data" : an object, see below
  #     ● "ttl" : the time-to-live in seconds of the value, an integer (or, in the rare case of an absolute
  #               expiration time, that expiration time as an ISO8601-formatted string)
  #     ● "timestamp" : an ISO8601-formatted string
  #
  #   Plus two attributes which are omitted in the common case:
  #     ● "permissions" : a string representing the bitmask of permissions. Generally this is "1110"
  #       (admin read, admin write, public read, not public write) in which case it is omitted.
  #       Values of type "HS_SECKEY" generally use "permissions":"1100".
  #     ● "references": an array of objects, each of which has attributes "index", an integer, and
  #       "handle", a string. Omitted when empty which is essentially always the case. (Perhaps
  #       references should be considered deprecated or reserved.)
  #
  #   Handle value data is binary data as a byte array. For ease of use, the JSON representation of handle
  #   values allows for a separate structured format of certain typical binary formats. In all cases the
  #   underlying data is simply a byte array.
  #
  #   Handle value data is either a string or an object with properties "format", a string, and "value".
  #     ● If "format"="string", "value" is a string, representing the data as a UTF-8 string.
  #     ● If "format"="base64", "value" is a string, with a Base64 encoding of the data.
  #     ● If "format"="hex", "value" is a string, with a hex encoding of the data.
  #     ● If "format"="admin", "value" is an object, representing an HS_ADMIN value,
  #       with properties "handle" (a string), "index" (an integer), and
  #       "permissions" (a string, representing the bitmask of permissions).
  #     ● If "format"="vlist", "value" is an list of objects, representing an HS_VLIST value; each object in
  #       the list has properties "handle" (a string) and "index" (an integer).
  #     ● If "format"="site", "value" is an object, representing an HS_SITE value. As the structure of this
  #       object is complicated and generally of limited technical interest it is currently omitted from
  #       this documentation.
  #     ● If "format"="key", "value" is an object in Json Web Key format, representing a public key.
  #
  # *************************************************************************************
  # DEV NOTE 2: "permissions" (a string, representing the bitmask of permissions)
  #   Therefore make the assumption was the same order as batch file processing.
  #
  #   # The admin permission set is twelve characters with the following order:
  #   #   add handle, delete handle, add naming authority, delete naming authority,
  #   #   modify values, remove values, add values, read values,
  #   #   modify administrator, remove administrator, add administrator and list handles.
  # *************************************************************************************
  ["111111111111", "110011110011", "000000000000"].each do |admin_permission_str|
    context "when admin permissions #{admin_permission_str}" do
      let(:admin_ps) { HandleRest::AdminPermissionSet.from_s(admin_permission_str) }

      it "has two handles" do
        expect(root_hs.index(PREFIX)).to contain_exactly(root_id.handle, admin_id.handle)
      end

      it "root handle has expected value lines" do
        expect(root_hs.get(root_id.handle)).to contain_exactly(root_admin_value_line, admin_admin_value_line, root_reference_list_value_line, admin_reference_list_value_line, root_secret_key_value_line)
      end

      it "admin handle has expected value lines" do
        expect(root_hs.get(admin_id.handle)).to contain_exactly(root_admin_value_line, admin_secret_key_value_line)
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
        # 101 HS_ADMIN 201:????????????:PREFIX/PREFIX
        # 1 URL <handle_url or new_handle_url>
        # before { admin_hs.post(handle, [root_admin_value_line, admin_admin_value_line, handle_url_value_line]) }
        #
        # For some reason only the root can create handles which is probably because we are testing against
        # an Independent Handle Server (IHS) a.k.a. a rogue server, otherwise the commented out 'before' above
        # should have worked, in theory, unless I configured it wrong which is also a possibility.
        before { root_hs.post(handle, [root_admin_value_line, admin_admin_value_line, handle_url_value_line]) }

        it "created the handle with expected values" do
          expect(admin_hs.get(handle)).to contain_exactly(root_admin_value_line, admin_admin_value_line, handle_url_value_line)
        end

        context "when updating the url value" do
          it "updated the handle with expected value" do # rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength
            if admin_ps.read_values && admin_ps.modify_values
              admin_hs.patch(handle, [handle_new_url_value_line])
              expect(admin_hs.get(handle)).to contain_exactly(root_admin_value_line, admin_admin_value_line, handle_new_url_value_line)
            else
              expect { admin_hs.patch(handle, [handle_new_url_value_line]) }.to raise_exception RuntimeError, "#{handle} - 400: Invalid Admin"
            end
          end
        end

        context "when deleting the handle" do
          it "delete the handle" do # rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength
            if admin_ps.read_values && admin_ps.remove_values
              admin_hs.delete(handle)
              expect { admin_hs.get(handle) }.to raise_exception(RuntimeError, "#{handle} - 100: Handle Not Found")
            else
              expect { admin_hs.delete(handle) }.to raise_exception(RuntimeError, "#{handle} - 400: Invalid Admin")
            end
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
