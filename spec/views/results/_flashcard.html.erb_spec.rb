require "rails_helper"

RSpec.describe "results/_flashcard.html.erb" do
  context "when the user saved it for review" do
    it "indicates that the flashcard was saved for review" do
      user = double("user")
      flashcard = build_stubbed(:flashcard)
      allow(flashcard).to(
        receive(:saved_for_review?).with(user).and_return(true)
      )

      render "results/flashcard", flashcard: flashcard, current_user: user

      expect(rendered).to include I18n.t("results.flashcard.saved_for_review")
      expect(rendered).to have_css(".kept-flashcard")
    end
  end

  context "when the user did not saved it for review" do
    it "does not indicate that the flashcard was saved for review" do
      user = double("user")
      flashcard = build_stubbed(:flashcard)
      allow(flashcard).to(
        receive(:saved_for_review?)
        .with(user)
        .and_return(false)
      )

      render "results/flashcard", flashcard: flashcard, current_user: user

      expect(rendered).not_to(
        include I18n.t("results.flashcard.saved_for_review")
      )
      expect(rendered).to_not have_css(".kept-flashcard")
    end
  end
end
