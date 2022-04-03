require "handle_rest"

describe HandleRest::Handle do
  it "has a private new method" do
    expect { described_class.new("Prefix", "Suffix") }.to raise_exception(NoMethodError, "private method `new' called for HandleRest::Handle:Class")
  end

  it "forces upcase" do
    expect(described_class.from_s("PrEfIx/SuFfIx").to_s).to eq "PREFIX/SUFFIX"
  end

  it "equivalent" do
    expect(described_class.from_s("PrEfIx/SuFfIx")).to eq described_class.from_s("pReFiX/sUfFiX")
  end

  it "not equivalent" do
    expect(described_class.from_s("PrEfIx/SuFfIx")).not_to eq described_class.from_s("sUfFiX/pReFiX")
  end

  it "prefix" do
    expect(described_class.from_s("PrEfIx/SuFfIx").prefix).to eq "PREFIX"
  end

  it "suffix" do
    expect(described_class.from_s("PrEfIx/SuFfIx").suffix).to eq "SUFFIX"
  end

  describe "#from_s" do
    subject(:from_s) { described_class.from_s(str) }

    context "when nil" do
      let(:str) {}

      it { expect { from_s }.to raise_exception(RuntimeError, "Handle string '#{str&.strip}' invalid.") }
    end

    context "when '/'" do
      let(:str) { "/" }

      it { expect { from_s }.to raise_exception(RuntimeError, "Handle string '#{str&.strip}' invalid.") }
    end

    context "when no '/'" do
      let(:str) { "prefix" }

      it { expect { from_s }.to raise_exception(RuntimeError, "Handle string '#{str&.strip}' invalid.") }
    end

    context "when no prefix" do
      let(:str) { "/suffix" }

      it { expect { from_s }.to raise_exception(RuntimeError, "Handle string '#{str&.strip}' invalid.") }
    end

    context "when no suffix" do
      let(:str) { "prefix/" }

      it { expect { from_s }.to raise_exception(RuntimeError, "Handle string '#{str&.strip}' invalid.") }
    end

    context "when valid" do
      let(:str) { "prefix/suffix" }

      it { expect { from_s }.not_to raise_exception }
    end

    context "when untrimmed" do
      let(:str) { " prefix/suffix " }

      it { expect { from_s }.not_to raise_exception }
    end

    context "when white space in 'pr efix'" do
      let(:str) { " pr efix/suffix " }

      it { expect { from_s }.to raise_exception(RuntimeError, "Handle string '#{str&.strip}' invalid.") }
    end

    context "when white space in '/ suffix'" do
      let(:str) { " prefix/ suffix " }

      it { expect { from_s }.to raise_exception(RuntimeError, "Handle string '#{str&.strip}' invalid.") }
    end
  end
end
