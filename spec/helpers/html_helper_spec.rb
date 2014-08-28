require "rails_helper"

describe HtmlHelper do
  describe "#truncate_html" do
    it "returns short text without tags or truncation" do
      expect(helper.truncate_html("<p>Discuss on the forum!</p>")).
        to eq("Discuss on the forum!")
    end

    it "returns shorter text with truncation" do
      expect(helper.truncate_html("<p>Ben and Joe tackle the third principle " \
                                  "in SOLID: the Liskov Substitution " \
                                  "Principle</p>")).
        to eq("Ben and Joe tackle the third principle in SOLID: the Liskov " \
              "Substitution...")
    end

    it "cuts on a short sentence" do
      expect(helper.truncate_html("<p>In this episode, Ben and Joe discuss " \
                                  "the Sandi Metz rules.\nYou can read the " \
                                  "notes.</p>")).
        to eq("In this episode, Ben and Joe discuss the Sandi Metz rules.")
    end

    it "cuts on a question" do
      expect(helper.truncate_html("<p>How do FP and OOP stack up? Wow.</p>")).
        to eq("How do FP and OOP stack up?")
    end
  end
end
