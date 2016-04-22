require "rails_helper"

describe AttemptsController do
  include StubCurrentUserHelper

  describe "#create" do
    it { requires_signed_in_user_to { post :create, flashcard_id: 1 } }

    context "when the user chose to save the flashcard" do
      it "sets a flash message" do
        stub_current_user_with(create(:user))
        flashcard = create(:flashcard)

        post(
          :create,
          flashcard_id: flashcard.id,
          attempt: { confidence: Attempt::LOW_CONFIDENCE }
        )

        expect(controller).to(
          set_flash.to(I18n.t("attempts.flashcard_saved"))
        )
      end
    end
  end
end
