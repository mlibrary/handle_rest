require "handle_rest"

describe HandleRest::Identity do
  let(:identity) { described_class.send(:new, index, handle) }
  let(:index) { 300 }
  let(:handle) { HandleRest::Handle.from_s("PREFIX/ADMIN") }

  it "#index returns expected index" do
    expect(identity.index).to eq index
  end

  it "#handle returns expected handle" do
    expect(identity.handle).to eq handle
  end

  it "#to_s returns expected string" do
    expect(identity.to_s).to eq "#{index}:#{handle}"
  end

  it "#self.from_s return instance" do
    expect(described_class.from_s("#{index}:#{handle}")).to eq identity
  end

  it "#== equivalent to self" do
    a = identity
    b = identity
    expect(a == b).to be true
  end

  it "#== equivalent to copy" do
    a = identity
    b = described_class.send(:new, index, handle)
    expect(a == b).to be true
  end

  it "#== not equivalent to other with different index" do
    a = identity
    b = described_class.send(:new, index + 1, handle)
    expect(a == b).to be false
  end

  it "#== not equivalent to other with different handle" do
    a = identity
    b = described_class.send(:new, index, HandleRest::Handle.from_s(handle.to_s.reverse))
    expect(a == b).to be false
  end

  it "#<=> returns zero when equivalent" do
    a = identity
    b = described_class.send(:new, index, handle)
    expect(a <=> b).to eq 0
  end

  it "#<=> returns non-zero when different index same handle" do
    a = identity
    b = described_class.send(:new, index + 1, handle)
    expect(a <=> b).to eq(-1)
  end

  it "#<=> returns non-zero when same index different handle" do
    a = identity
    b = described_class.send(:new, index, HandleRest::Handle.from_s(handle.to_s.reverse))
    expect(a <=> b).to eq(1)
  end
end
