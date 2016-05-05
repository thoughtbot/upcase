require "rails_helper"

describe Subscriber::ResubscriptionsController do
  context "#create" do
    it "calls #fulfill on a `Resubscription` and it works" do
      fake_resubscription = double(fulfill: true)
      create(:plan, sku: "professional")
      user = create(:user)
      allow(Resubscription).
        to receive(:new).
        with(user: user, plan: Plan.professional).
        and_return(fake_resubscription)
      sign_in_as user

      post :create

      expect(flash[:notice]).to eq t(".success")
      expect(response).to redirect_to(my_account_path)
    end

    it "calls #fulfill on a `Reactivation` and it does not work" do
      fake_resubscription = double(fulfill: false)
      create(:plan, sku: "professional")
      user = create(:user)
      allow(Resubscription).
        to receive(:new).
        with(user: user, plan: Plan.professional).
        and_return(fake_resubscription)
      sign_in_as user

      post :create

      expect(flash[:error]).to eq t(".failure")
      expect(response).to redirect_to(my_account_path)
    end
  end

  def t(key)
    I18n.t("subscriptions.flashes.resubscribe#{key}")
  end
end
