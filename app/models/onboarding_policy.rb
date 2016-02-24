class OnboardingPolicy
  def initialize(user)
    @user = user
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

  attr_reader :user

  def route_helpers
    Rails.application.routes.url_helpers
  end

  def user_only_has_access_to_weekly_iteration?
    user.subscriber? && !user_has_trails?
  end

  def full_subscriber_with_incomplete_welcome_flow?
    user.subscriber? &&
      user_has_trails? &&
      welcome_flow_incomplete?
  end

  def user_has_trails?
    user.has_access_to?(Trail)
  end

  def welcome_flow_incomplete?
    !user.completed_welcome?
  end
end
