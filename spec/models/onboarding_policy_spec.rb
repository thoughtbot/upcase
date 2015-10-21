require "rails_helper"

describe OnboardingPolicy do
  include Rails.application.routes.url_helpers

  describe "#needs_onboarding?" do
    context "for a user without a subscription" do
      it "returns false" do
        onboarding_policy = OnboardingPolicy.new(NullLicense.new)

        expect(onboarding_policy.needs_onboarding?).to eq(false)
      end
    end

    context "for a user with a subscription" do
      context "with access limited to the weekly iteration" do
        it "returns false" do
          license = weekly_iteration_license

          onboarding_policy = OnboardingPolicy.new(license)

          expect(onboarding_policy.needs_onboarding?).to eq(false)
        end
      end

      context "with a full subscription" do
        context "who hasn't completed the welcome onboarding flow" do
          it "returns true" do
            license = full_subscriber_license(completed_welcome: false)

            onboarding_policy = OnboardingPolicy.new(license)

            expect(onboarding_policy.needs_onboarding?).to eq(true)
          end
        end

        context "who has completed the onboarding welcome flow" do
          it "returns false" do
            license = full_subscriber_license(completed_welcome: true)

            onboarding_policy = OnboardingPolicy.new(license)

            expect(onboarding_policy.needs_onboarding?).to eq(false)
          end
        end
      end
    end
  end

  describe "#onboarded?" do
    it "returns the inverse of #needs_onboarding?" do
      onboarding_policy = OnboardingPolicy.new(NullLicense.new)

      expect(onboarding_policy.onboarded?).
        to eq(!onboarding_policy.needs_onboarding?)
    end
  end

  describe "#root_path" do
    it "returns the weekly iteration path for weekly iteration subscribers" do
      stub_weekly_iteration_path
      license = weekly_iteration_license

      onboarding_policy = OnboardingPolicy.new(license)

      expect(onboarding_policy.root_path).to eq(weekly_iteration_path)
    end

    it "returns the welcome page path for new full subscribers" do
      license = full_subscriber_license(completed_welcome: false)

      onboarding_policy = OnboardingPolicy.new(license)

      expect(onboarding_policy.root_path).to eq(welcome_path)
    end

    it "returns the pratice path for users who have completed the onboarding" do
      license = full_subscriber_license(completed_welcome: true)

      onboarding_policy = OnboardingPolicy.new(license)

      expect(onboarding_policy.root_path).to eq(practice_path)
    end
  end

  def weekly_iteration_license
    double("License", active?: true).tap do |license|
      allow(license).to receive(:grants_access_to?).
        with(:trails).
        and_return(false)
    end
  end

  def full_subscriber_license(completed_welcome:)
    double(
      "License",
      active?: true,
      completed_welcome?: completed_welcome,
    ).tap do |license|
      allow(license).to receive(:grants_access_to?).
        with(:trails).
        and_return(true)
    end
  end

  def stub_weekly_iteration_path
    allow(Show).to receive(:the_weekly_iteration).and_return("/weekly-show")
  end

  def weekly_iteration_path
    show_path(Show.the_weekly_iteration)
  end
end
