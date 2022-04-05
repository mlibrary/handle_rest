require "handle_rest"

describe HandleRest::EmailValue do
  let(:email_value) { described_class.new(email) }
  let(:email) { "wolverine@umich.edu" }

  it "is derived from value" do
    expect(email_value).to be_a_kind_of(HandleRest::Value)
  end

  it "#type == 'EMAIL'" do
    expect(email_value.type).to eq "EMAIL"
  end

  it "#to_s returns email" do
    expect(email_value.to_s).to eq email
  end

  it "#self.from_s returns instance" do
    expect(described_class.from_s(email)).to eq email_value
  end

  it "#self.from_h returns instance" do
    expect(described_class.from_h("string", email)).to eq email_value
  end

  it "#self.from_h raises exception on wrong type" do
    expect { described_class.from_h("String", email) }.to raise_exception(RuntimeError, "EmailValue unexpected format 'String'")
  end

  context "when email nil" do
    let(:email) { nil }

    it "#self.to_s raises exception" do
      expect { email_value.to_s }.to raise_exception(URI::InvalidComponentError, "unrecognised opaque part for mailtoURL: #{email}?subject=email")
    end

    it "#self.from_s raises exception" do
      expect { described_class.from_s(email) }.to raise_exception(URI::InvalidComponentError, "unrecognised opaque part for mailtoURL: #{email}?subject=email")
    end

    it "#self.from_h raises exception" do
      expect { described_class.from_h("string", email) }.to raise_exception(URI::InvalidComponentError, "unrecognised opaque part for mailtoURL: #{email}?subject=email")
    end
  end

  context "when email invalid form" do
    let(:email) { "wolverine" }

    it "#self.to_s raises exception" do
      expect { email_value.to_s }.to raise_exception(URI::InvalidComponentError, "unrecognised opaque part for mailtoURL: #{email}?subject=email")
    end

    it "#self.from_s raises exception" do
      expect { described_class.from_s(email) }.to raise_exception(URI::InvalidComponentError, "unrecognised opaque part for mailtoURL: #{email}?subject=email")
    end

    it "#self.from_h raises exception" do
      expect { described_class.from_h("string", email) }.to raise_exception(URI::InvalidComponentError, "unrecognised opaque part for mailtoURL: #{email}?subject=email")
    end
  end
end
