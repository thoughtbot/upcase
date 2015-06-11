require "rails_helper"

describe AttemptsController do
  include StubCurrentUserHelper

  describe "#create" do
    it "redirects if not logged in" do
      post :create, flashcard_id: 1

      expect(response).to redirect_to(sign_in_path)
    end

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
          set_the_flash.to(I18n.t("attempts.flashcard_saved"))
        )
      end
    end
  end
end
