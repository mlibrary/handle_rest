require "handle_rest"

describe HandleRest do
  describe "#self.boolean_to_character" do
    it "true is 1" do
      expect(described_class.boolean_to_character(true)).to eq "1"
    end

    it "false is 0" do
      expect(described_class.boolean_to_character(false)).to eq "0"
    end

    it "nil raises exception" do
      expect { described_class.boolean_to_character(nil) }.to raise_exception(RuntimeError, "'' to character must be true or false.")
    end
  end

  describe "#self.character_to_boolean" do
    it "1 is true" do
      expect(described_class.character_to_boolean("1")).to be true
    end

    it "0 is false" do
      expect(described_class.character_to_boolean("0")).to be false
    end

    it "nil raises exception" do
      expect { described_class.character_to_boolean(nil) }.to raise_exception(RuntimeError, "'' to boolean must be '1' or '0'.")
    end
  end
end
