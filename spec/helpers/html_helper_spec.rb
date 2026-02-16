require "rails_helper"

RSpec.describe HtmlHelper do
  describe "#truncate_html" do
    it "returns the plain text after rendering to markdown" do
      input = "[hello world link](http://example.com)"

      expect(helper.truncate_html(input)).to eq("hello world link")
    end

    it "removes html tags" do
      expect(helper.truncate_html("<p>Discuss</p>")).to eq("Discuss")
    end

    it "returns short text without truncating" do
      result = helper.truncate_html("<p>Discuss on the forum!</p>")

      expect(result).to eq("Discuss on the forum!")
    end

    it "truncates longer text" do
      expect(helper.truncate_html("Ben and Joe tackle the third principle " \
                                  "in SOLID: the Liskov Substitution " \
                                  "Principle"))
        .to eq("Ben and Joe tackle the third principle in SOLID: the Liskov " \
              "Substitution...")
    end

    it "uses a custom length if provided" do
      expect(helper.truncate_html("123456789", length: 6)).to eq("123...")
    end
  end
end
