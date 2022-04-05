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
      expect { described_class.new(1, HandleRest::UrnValue.new(nil)) }.not_to raise_exception
    end

    it "default permission set == '1110'" do
      expect(described_class.new(1, HandleRest::UrnValue.new(nil)).permissions).to eq HandleRest::PermissionSet.from_s("1110")
    end

    it "default permission set == '1100' for HS_PUBKEY" do
      expect(described_class.new(1, HandleRest::PublicKeyValue.new(nil)).permissions).to eq HandleRest::PermissionSet.from_s("1100")
    end

    it "default permission set == '1100' for HS_SECKEY" do
      expect(described_class.new(1, HandleRest::SecretKeyValue.new(nil)).permissions).to eq HandleRest::PermissionSet.from_s("1100")
    end

    it "raise exception on non-permission set permission set" do
      expect { described_class.new(1, HandleRest::UrnValue.new(nil), permissions: HandleRest::AdminPermissionSet.new) }.to raise_exception(RuntimeError, "permission set must be a kind of HandleRest::PermissionSet")
    end

    it "does NOT raise exception on permission set permission set" do
      expect { described_class.new(1, HandleRest::UrnValue.new(nil), permissions: HandleRest::PermissionSet.new) }.not_to raise_exception
    end

    it "default time to live == 86400" do
      expect(described_class.new(1, HandleRest::UrnValue.new(nil)).time_to_live).to eq 86400
    end

    it "raise exception on non-integer time to live" do
      expect { described_class.new(1, HandleRest::UrnValue.new(nil), time_to_live: "zero") }.to raise_exception(RuntimeError, "time to live must be an integer greater than or equal to zero")
    end

    it "raise exception on negative integer time to live" do
      expect { described_class.new(1, HandleRest::UrnValue.new(nil), time_to_live: -1) }.to raise_exception(RuntimeError, "time to live must be an integer greater than or equal to zero")
    end

    it "does NOT raise exception on zero time to live" do
      expect { described_class.new(1, HandleRest::UrnValue.new(nil), time_to_live: 0) }.not_to raise_exception
    end
  end

  describe "methods" do
    let(:value_line) { described_class.new(index, value, permissions: permissions, time_to_live: ttl) }
    let(:index) { 1 }
    let(:value) { HandleRest::UrnValue.new("http://www.umich.edu") }
    let(:permissions) { HandleRest::PermissionSet.from_s("0011") }
    let(:ttl) { 1999 }

    it "#as_json returns hash" do
      expect(value_line.as_json).to eq({index: index, type: value.type, data: value, ttl: ttl, permissions: permissions.to_s})
    end

    it "#to_json calls #as_json" do
      expect(value_line.to_json).to eq({index: index, type: value.type, data: value, ttl: ttl, permissions: permissions.to_s}.to_json)
    end

    it "#self.from_h returns instance" do
      expect(described_class.from_h({"index" => index.to_s, "type" => value.type, "data" => {"format" => "string", "value" => value.value.to_s}, "permissions" => permissions.to_s, "time_to_live" => ttl})).to eq value_line
    end

    it "#self.nil returns instance of NilValueLine" do
      expect(described_class.nil).to eq HandleRest::NilValueLine.new
    end
  end
end
