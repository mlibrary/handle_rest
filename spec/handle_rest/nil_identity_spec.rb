require "handle_rest"

describe HandleRest::NilIdentity do
  let(:nil_identity) { described_class.from_s(str) }
  let(:str) { "#{index}:#{handle}" }
  let(:index) { 300 }
  let(:handle) { HandleRest::Handle.from_s("PREFIX/ADMIN") }

  it "has a private new method" do
    expect { described_class.new(index, handle) }.to raise_exception(NoMethodError, "private method `new' called for HandleRest::NilIdentity:Class")
  end

  it "is derived from Identity" do
    expect(nil_identity).to be_a_kind_of(HandleRest::Identity)
  end

  it "#nil? is true" do
    expect(nil_identity.nil?).to be true
  end

  it "#index returns zero" do
    expect(nil_identity.index).to eq 0
  end

  it "#handle returns nil handle" do
    expect(nil_identity.handle).to eq HandleRest::Handle.nil
  end

  it "#to_s returns expected string" do
    expect(nil_identity.to_s).to eq "0:/"
  end

  describe "#from_s" do
    context "when nil" do
      let(:str) {}

      it { expect { nil_identity }.not_to raise_exception }

      it { expect(nil_identity.to_s).to eq "0:/" }
    end

    context "when valid" do
      let(:str) { "1:prefix/suffix" }

      it { expect { nil_identity }.not_to raise_exception }

      it { expect(nil_identity.to_s).to eq "0:/" }
    end
  end

  describe "equivalence and three-way comparison" do
    let(:nothing) { described_class.from_s }
    let(:anything) { described_class.from_s(str) }
    let(:something) { HandleRest::Identity.from_s(str) }

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
