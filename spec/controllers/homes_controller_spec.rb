require "rails_helper"

describe HomesController do
  context "the user is not logged in" do
    it "renders the content of /join, but stays on /" do
      get :show

      expect(response).to render_template("subscriptions/new")
    end
  end

  context "the user is logged in" do
    it "delegates to the OnboaringPolicy to determine where to send the user" do
      user = create(:user)
      onboarding_policy = stub_onbarding_policy(user)
      sign_in_as user

      get :show

      expect(response).to redirect_to(onboarding_policy.root_path)
    end
  end

  def stub_onbarding_policy(user)
    instance_double(OnboardingPolicy, root_path: "/my-route").tap do |policy|
      allow(OnboardingPolicy).to receive(:new).with(user).and_return(policy)
    end
  end
end
