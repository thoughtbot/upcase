require "rails_helper"

describe UnsubscribesController do
  include UnsubscribesHelper

  describe "#show" do
    context "with a valid unsubscribe token" do
      it "updates the user's unsubscribe preference" do
        user = create(:user)

        get :show, params: {token: unsubscribe_token_for(user)}

        expect(user.reload).to be_unsubscribed_from_emails
      end
    end

    context "with an invalid token" do
      it "displays a relavant error page and status to the user" do
        get :show, params: {token: "not-a-real-unsub-token"}

        expect(response).to render_template("unsubscribes/error")
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "when the user can't be found" do
      it "displays a relavant error page and status to the user" do
        get :show, params: {
          token: unsubscribe_token_for(double("not-a-user", id: 99999))
        }

        expect(response).to render_template("unsubscribes/error")
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  def unsubscribe_token_for(user)
    unsubscribe_token_verifier.generate(user.id)
  end
end
