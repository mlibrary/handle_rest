require "handle_rest"

describe HandleRest::PermissionSet do
  describe "#to_s" do
    it "defaults is four ones" do
      expect(described_class.new.to_s).to eq "1111"
    end

    it "admin_read flag is zero" do
      expect(described_class.new(admin_read: false).to_s).to eq "0111"
    end

    it "admin_write flag is zero" do
      expect(described_class.new(admin_write: false).to_s).to eq "1011"
    end

    it "public_read flag is zero" do
      expect(described_class.new(public_read: false).to_s).to eq "1101"
    end

    it "public_write flag is zero" do
      expect(described_class.new(public_write: false).to_s).to eq "1110"
    end
  end

  describe "#from_s" do
    it "default is four ones" do
      expect(described_class.from_s("1111")).to eq described_class.new
    end

    it "admin_read flag is zero" do
      expect(described_class.from_s("0111")).to eq described_class.new(admin_read: false)
    end

    it "admin_write flag is zero" do
      expect(described_class.from_s("1011")).to eq described_class.new(admin_write: false)
    end

    it "public_read flag is zero" do
      expect(described_class.from_s("1101")).to eq described_class.new(public_read: false)
    end

    it "public_write flag is zero" do
      expect(described_class.from_s("1110")).to eq described_class.new(public_write: false)
    end
  end
end
