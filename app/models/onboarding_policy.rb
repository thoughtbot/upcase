class OnboardingPolicy
  def initialize(license)
    @license = license
  end

  def needs_onboarding?
    full_subscriber_with_incomplete_welcome_flow?
  end

  def onboarded?
    !needs_onboarding?
  end

  def root_path
    if user_only_has_access_to_weekly_iteration?
      route_helpers.show_path(Show.the_weekly_iteration)
    elsif needs_onboarding?
      route_helpers.welcome_path
    else
      route_helpers.practice_path
    end
  end

  private

  attr_reader :license

  def route_helpers
    Rails.application.routes.url_helpers
  end

  def user_only_has_access_to_weekly_iteration?
    license.active? && !licensed_for_trails?
  end

  def full_subscriber_with_incomplete_welcome_flow?
    license.active? && licensed_for_trails? && welcome_flow_incomplete?
  end

  def licensed_for_trails?
    license.grants_access_to?(:trails)
  end

  def welcome_flow_incomplete?
    !license.completed_welcome?
  end
end
