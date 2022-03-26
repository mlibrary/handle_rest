require "handle_rest"

describe HandleRest::Identifier do
  it "has a private new method" do
    expect { described_class.new("Prefix", "Suffix") }.to raise_exception(NoMethodError, "private method `new' called for HandleRest::Identifier:Class")
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
end
