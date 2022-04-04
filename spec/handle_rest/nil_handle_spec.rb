require "handle_rest"

describe HandleRest::NilHandle do
  let(:nil_handle) { described_class.from_s(str) }
  let(:str) { "PREFIX/SUFFIX" }

  it "has a private new method" do
    expect { described_class.new("Prefix", "Suffix") }.to raise_exception(NoMethodError, "private method `new' called for HandleRest::NilHandle:Class")
  end

  it "is derived from Handle" do
    expect(nil_handle).to be_a_kind_of(HandleRest::Handle)
  end

  it "#nil? is true" do
    expect(nil_handle.nil?).to be true
  end

  it "#prefix returns empty string" do
    expect(nil_handle.prefix).to eq ""
  end

  it "#suffix returns empty string" do
    expect(nil_handle.suffix).to eq ""
  end

  it "#to_s returns expected string" do
    expect(nil_handle.to_s).to eq "/"
  end

  describe "#from_s" do
    context "when nil" do
      let(:str) {}

      it { expect { nil_handle }.not_to raise_exception }

      it { expect(nil_handle.to_s).to eq "/" }
    end

    context "when valid" do
      let(:str) { "prefix/suffix" }

      it { expect { nil_handle }.not_to raise_exception }

      it { expect(nil_handle.to_s).to eq "/" }
    end
  end

  describe "equivalence and three-way comparison" do
    let(:nothing) { described_class.from_s }
    let(:anything) { described_class.from_s(str) }
    let(:something) { HandleRest::Handle.from_s(str) }

    describe "#==" do
      it "anything equivalent to nothing" do
        expect(anything == nothing).to be true
      end

      it "anything not equivalent to something" do
        expect(anything != something).to be true
      end
    end

    describe "#<=>" do
      it "anything <=> nothing is 0" do
        expect(anything <=> nothing).to eq 0
      end

      it "anything <=> something is -1" do
        expect(anything <=> something).to eq(-1)
      end

      it "something <=> anything is 1" do
        expect(something <=> anything).to eq 1
      end
    end
  end
end
