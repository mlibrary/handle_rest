require "handle_rest"

describe HandleRest::ValueLine do
  describe "#intialize" do
    it "raise exception on nil index" do
      expect { described_class.new(nil, nil) }.to raise_exception(RuntimeError, "index must be a positive integer")
    end

    it "raise exception on non-integer index" do
      expect { described_class.new(1.0, nil) }.to raise_exception(RuntimeError, "index must be a positive integer")
    end

    it "raise exception on negative integer index" do
      expect { described_class.new(-1, nil) }.to raise_exception(RuntimeError, "index must be a positive integer")
    end

    it "raise exception on zero index" do
      expect { described_class.new(0, nil) }.to raise_exception(RuntimeError, "index must be a positive integer")
    end

    it "raise exception on nil value" do
      expect { described_class.new(1, nil) }.to raise_exception(RuntimeError, "value must be a kind of HandleRest::Value")
    end

    it "raise exception on non-value value" do
      expect { described_class.new(1, "value") }.to raise_exception(RuntimeError, "value must be a kind of HandleRest::Value")
    end

    it "raise exception on value value" do
      expect { described_class.new(1, HandleRest::Value.new(nil)) }.to raise_exception(RuntimeError, "this method should be overridden and return value type")
    end

    it "does NOT raise exception on positive integer index and derived value value" do
      expect { described_class.new(1, HandleRest::UrlValue.new(nil)) }.not_to raise_exception
    end

    it "default permission set == '1110'" do
      expect(described_class.new(1, HandleRest::UrlValue.new(nil)).permission_set).to eq HandleRest::PermissionSet.from_s("1110")
    end

    it "default permission set == '1100' for HS_PUBKEY" do
      expect(described_class.new(1, HandleRest::PublicKeyValue.new(nil)).permission_set).to eq HandleRest::PermissionSet.from_s("1100")
    end

    it "default permission set == '1100' for HS_SECKEY" do
      expect(described_class.new(1, HandleRest::SecretKeyValue.new(nil)).permission_set).to eq HandleRest::PermissionSet.from_s("1100")
    end

    it "raise exception on non-permission set permission set" do
      expect { described_class.new(1, HandleRest::UrlValue.new(nil), permission_set: HandleRest::AdminPermissionSet.new) }.to raise_exception(RuntimeError, "permission set must be a kind of HandleRest::PermissionSet")
    end

    it "does NOT raise exception on permission set permission set" do
      expect { described_class.new(1, HandleRest::UrlValue.new(nil), permission_set: HandleRest::PermissionSet.new) }.not_to raise_exception
    end

    it "default time to live == 86400" do
      expect(described_class.new(1, HandleRest::UrlValue.new(nil)).time_to_live).to eq 86400
    end

    it "raise exception on non-integer time to live" do
      expect { described_class.new(1, HandleRest::UrlValue.new(nil), time_to_live: "zero") }.to raise_exception(RuntimeError, "time to live must be an integer greater than or equal to zero")
    end

    it "raise exception on negative integer time to live" do
      expect { described_class.new(1, HandleRest::UrlValue.new(nil), time_to_live: -1) }.to raise_exception(RuntimeError, "time to live must be an integer greater than or equal to zero")
    end

    it "does NOT raise exception on zero time to live" do
      expect { described_class.new(1, HandleRest::UrlValue.new(nil), time_to_live: 0) }.not_to raise_exception
    end
  end
end
