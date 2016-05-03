require "rails_helper"

describe Subscriber::ResubscriptionsController do
  context "#create" do
    before { create(:plan, sku: "professional") }

    it "calls #fulfill on a `Resubscription` and it works" do
      create_user_that_can_resubscribe(can_resubcribe: true)

      post :create

      expect(flash[:notice]).to eq t(".success")
      expect(response).to redirect_to(my_account_path)
    end

    it "calls #fulfill on a `Reactivation` and it does not work" do
      create_user_that_can_resubscribe(can_resubcribe: false)

      post :create

      expect(flash[:error]).to eq t(".failure")
      expect(response).to redirect_to(my_account_path)
    end
  end

  def t(key)
    I18n.t("subscriptions.flashes.resubscribe#{key}")
  end

  def create_user_that_can_resubscribe(can_resubcribe:)
    fake_resubscription = double(fulfill: can_resubcribe)
    user = create(:user)
    allow(Resubscription).
      to receive(:new).
      with(user: user, plan: Plan.professional).
      and_return(fake_resubscription)
    sign_in_as user
  end
end
