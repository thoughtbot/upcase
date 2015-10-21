require "rails_helper"

describe HomesController do
  context "the user is not logged in" do
    it "redirects to /join" do
      get :show

      expect(response).to redirect_to join_path
    end
  end

  context "the user is logged in" do
    it "delegates to the OnboaringPolicy to determine where to send the user" do
      onboarding_policy = stub_onbarding_policy
      sign_in

      get :show

      expect(response).to redirect_to(onboarding_policy.root_path)
    end
  end

  def stub_onbarding_policy
    instance_double(OnboardingPolicy, root_path: "/my-route").tap do |policy|
      allow(OnboardingPolicy).to receive(:new).and_return(policy)
    end
  end
end
