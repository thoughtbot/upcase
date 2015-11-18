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

  describe "#page_title_with_app_name" do
    context "with an empty page_title content_for" do
      it "returns the application name" do
        result = helper.page_title_with_app_name(nil, "Upcase")

        expect(result).to eq "Upcase"
      end
    end

    context "with a specified page_title content_for" do
      it "concatenates the page_title content and the app name" do
        result = helper.page_title_with_app_name("TDD", "Upcase")

        expect(result).to eq "TDD from Upcase"
      end
    end
  end
end
