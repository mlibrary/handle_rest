require "handle_rest"

describe HandleRest::AdminPermissionSet do
  describe "#to_s" do
    it "defaults is twelve ones" do
      expect(described_class.new.to_s).to eq "111111111111"
    end

    it "add_handle flag is zero" do
      expect(described_class.new(add_handle: false).to_s).to eq "011111111111"
    end

    it "delete_handle flag is zero" do
      expect(described_class.new(delete_handle: false).to_s).to eq "101111111111"
    end

    it "add_naming_authority flag is zero" do
      expect(described_class.new(add_naming_authority: false).to_s).to eq "110111111111"
    end

    it "delete_naming_authority flag is zero" do
      expect(described_class.new(delete_naming_authority: false).to_s).to eq "111011111111"
    end

    it "modify_values flag is zero" do
      expect(described_class.new(modify_values: false).to_s).to eq "111101111111"
    end

    it "remove_values flag is zero" do
      expect(described_class.new(remove_values: false).to_s).to eq "111110111111"
    end

    it "add_values flag is zero" do
      expect(described_class.new(add_values: false).to_s).to eq "111111011111"
    end

    it "read_values flag is zero" do
      expect(described_class.new(read_values: false).to_s).to eq "111111101111"
    end

    it "modify_administrator flag is zero" do
      expect(described_class.new(modify_administrator: false).to_s).to eq "111111110111"
    end

    it "remove_administrator flag is zero" do
      expect(described_class.new(remove_administrator: false).to_s).to eq "111111111011"
    end

    it "add_administrator flag is zero" do
      expect(described_class.new(add_administrator: false).to_s).to eq "111111111101"
    end

    it "list_handles flag is zero" do
      expect(described_class.new(list_handles: false).to_s).to eq "111111111110"
    end
  end

  describe "#from_s" do
    it "default is twelve ones" do
      expect(described_class.from_s("111111111111")).to eq described_class.new
    end

    it "add_handle flag is zero" do
      expect(described_class.from_s("011111111111")).to eq described_class.new(add_handle: false)
    end

    it "delete_handle flag is zero" do
      expect(described_class.from_s("101111111111")).to eq described_class.new(delete_handle: false)
    end

    it "add_naming_authority flag is zero" do
      expect(described_class.from_s("110111111111")).to eq described_class.new(add_naming_authority: false)
    end

    it "delete_naming_authority flag is zero" do
      expect(described_class.from_s("111011111111")).to eq described_class.new(delete_naming_authority: false)
    end

    it "modify_values flag is zero" do
      expect(described_class.from_s("111101111111")).to eq described_class.new(modify_values: false)
    end

    it "remove_values flag is zero" do
      expect(described_class.from_s("111110111111")).to eq described_class.new(remove_values: false)
    end

    it "add_values flag is zero" do
      expect(described_class.from_s("111111011111")).to eq described_class.new(add_values: false)
    end

    it "read_values flag is zero" do
      expect(described_class.from_s("111111101111")).to eq described_class.new(read_values: false)
    end

    it "modify_administrator flag is zero" do
      expect(described_class.from_s("111111110111")).to eq described_class.new(modify_administrator: false)
    end

    it "remove_administrator flag is zero" do
      expect(described_class.from_s("111111111011")).to eq described_class.new(remove_administrator: false)
    end

    it "add_administrator flag is zero" do
      expect(described_class.from_s("111111111101")).to eq described_class.new(add_administrator: false)
    end

    it "list_handles flag is zero" do
      expect(described_class.from_s("111111111110")).to eq described_class.new(list_handles: false)
    end
  end
end
