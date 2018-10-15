require "rails_helper"

describe OnboardingPolicy do
  include Rails.application.routes.url_helpers

  describe "#needs_onboarding?" do
    it "returns false" do
      user = build_stubbed(:user)

      onboarding_policy = OnboardingPolicy.new(user)

      expect(onboarding_policy.needs_onboarding?).to eq(false)
    end
  end

  describe "#root_path" do
    it "returns the pratice path" do
      user = create(:subscriber, :with_full_subscription, :onboarded)

      onboarding_policy = OnboardingPolicy.new(user)

      expect(onboarding_policy.root_path).to eq(practice_path)
    end
  end

  def stub_weekly_iteration_path
    allow(Show).to receive(:the_weekly_iteration).and_return("/weekly-show")
  end

  def weekly_iteration_path
    show_path(Show.the_weekly_iteration)
  end
end
