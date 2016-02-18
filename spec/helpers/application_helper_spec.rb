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

  describe "#encourage_user_to_pay?" do
    context "when current_user has an active_subscription" do
      context "and is on a landing page" do
        it "returns true" do
          stub_user(has_active_subscription: true, on_landing_page: true)

          result = helper.encourage_user_to_pay?

          expect(result).to be(true)
        end
      end

      context "and is not on a landing page" do
        it "returns false" do
          stub_user(has_active_subscription: true, on_landing_page: false)

          result = helper.encourage_user_to_pay?

          expect(result).to be(false)
        end
      end
    end

    context "when current_user doesn't have an active_subscription" do
      context "and is on a landing page" do
        it "returns true" do
          stub_user(has_active_subscription: false, on_landing_page: false)

          result = helper.encourage_user_to_pay?

          expect(result).to be(true)
        end
      end

      context "and is not on a landing page" do
        it "returns true" do
          stub_user(has_active_subscription: false, on_landing_page: false)

          result = helper.encourage_user_to_pay?

          expect(result).to be(true)
        end
      end
    end
  end

  def stub_user(has_active_subscription:, on_landing_page:)
    user = double(:user, has_active_subscription?: has_active_subscription)
    allow(helper).to receive(:signed_out?).and_return(false)
    allow(helper).to receive(:current_user).and_return(user)
    assign(:landing_page, on_landing_page)
  end
end
