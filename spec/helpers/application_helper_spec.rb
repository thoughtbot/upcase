require "rails_helper"

describe ApplicationHelper do
  describe "#exercise_path" do
    it "returns the remote URL for the exercise" do
      exercise = build_stubbed(:exercise)

      result = helper.exercise_path(exercise)

      expect(result).to eq(exercise.url)
    end
  end

  describe "#format_markdown" do
    it "returns the rendered html for the input markdown" do
      markdown = "hello **world**"

      formatted = helper.format_markdown(markdown)

      expect(formatted).to eq("<p>hello <strong>world</strong></p>\n")
    end

    context "with an empty input" do
      it "returns an empty string" do
        expect(helper.format_markdown(nil)).to eq("")
      end
    end
  end

  describe "#github_auth_path" do
    context "without query parameters" do
      it "generates a bare path" do
        expect(helper.github_auth_path).to eq("/auth/github")
      end
    end

    context "with query parameters" do
      it "adds the query parameters to the generated path" do
        expect(helper.github_auth_path(one: "1", two: "2")).
          to eq("/auth/github?one=1&two=2")
      end
    end
  end
end
