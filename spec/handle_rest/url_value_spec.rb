require "handle_rest"

describe HandleRest::UrlValue do
  let(:url_value) { described_class.new(url) }
  let(:url) { "https://www.umich.edu" }

  it "is derived from value" do
    expect(url_value).to be_a_kind_of(HandleRest::Value)
  end

  it "#type == 'URL'" do
    expect(url_value.type).to eq "URL"
  end

  it "#to_s returns url" do
    expect(url_value.to_s).to eq url
  end

  it "#self.from_s returns instance" do
    expect(described_class.from_s(url)).to eq url_value
  end

  it "#self.from_h returns instance" do
    expect(described_class.from_h("string", url)).to eq url_value
  end

  it "#self.from_h raises exception on wrong type" do
    expect { described_class.from_h("String", url) }.to raise_exception(RuntimeError, "UrlValue unexpected format 'String'")
  end

  context "when url nil" do
    let(:url) {}

    it "#self.to_s raises exception" do
      expect { url_value.to_s }.to raise_exception(URI::InvalidURIError, "bad URI(is not URI?): nil")
    end

    it "#self.from_s raises exception" do
      expect { described_class.from_s(url) }.to raise_exception(URI::InvalidURIError, "bad URI(is not URI?): nil")
    end

    it "#self.from_h raises exception" do
      expect { described_class.from_h("string", url) }.to raise_exception(URI::InvalidURIError, "bad URI(is not URI?): nil")
    end
  end

  context "when url invalid form" do
    let(:url) { "i n v a l i d" }

    it "#self.to_s raises exception" do
      expect { url_value.to_s }.to raise_exception(URI::InvalidURIError, "bad URI(is not URI?): \"#{url}\"")
    end

    it "#self.from_s raises exception" do
      expect { described_class.from_s(url) }.to raise_exception(URI::InvalidURIError, "bad URI(is not URI?): \"#{url}\"")
    end

    it "#self.from_h raises exception" do
      expect { described_class.from_h("string", url) }.to raise_exception(URI::InvalidURIError, "bad URI(is not URI?): \"#{url}\"")
    end
  end
end
