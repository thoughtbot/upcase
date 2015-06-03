require "rails_helper"

describe "results/_question.html.erb" do
  context "when the user saved it for review" do
    it "indicates that the question was saved for review" do
      user = double("user")
      question = build_stubbed(:question)
      allow(question).to receive(:saved_for_review?).with(user).and_return(true)

      render "results/question", question: question, current_user: user

      expect(rendered).to include I18n.t("results.question.saved_for_review")
      expect(rendered).to have_css(".kept-flashcard")
    end
  end

  context "when the user did not saved it for review" do
    it "does not indicate that the question was saved for review" do
      user = double("user")
      question = build_stubbed(:question)
      allow(question).to(
        receive(:saved_for_review?).
        with(user).
        and_return(false)
      )

      render "results/question", question: question, current_user: user

      expect(rendered).not_to(
        include I18n.t("results.question.saved_for_review")
      )
      expect(rendered).to_not have_css(".kept-flashcard")
    end
  end
end
