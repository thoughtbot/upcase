class ApplicationController < ActionController::Base
  include Clearance::Controller

  protect_from_forgery with: :exception
  before_filter :capture_campaign_params
  layout :determine_layout

  protected

  def analytics
    Analytics.new(current_user)
  end

  def must_be_admin
    unless current_user_is_admin?
      flash[:error] = 'You do not have permission to view that page.'
      redirect_to root_url
    end
  end

  def must_be_team_owner
    require_login
    if signed_in?
      if current_team.blank? || !current_team.owner?(current_user)
        deny_access("You must be the owner of the team.")
      end
    end
  end

  def must_be_subscription_owner
    unless current_user_is_subscription_owner?
      deny_access("You must be the owner of the subscription.")
    end
  end

  def current_user_is_subscription_owner?
    current_user_has_active_subscription? &&
      current_user.subscription.owner?(current_user)
  end
  helper_method :current_user_is_subscription_owner?

  def current_user_has_active_subscription?
    current_user && current_user.has_active_subscription?
  end
  helper_method :current_user_has_active_subscription?

  def current_user_is_eligible_for_annual_upgrade?
    current_user_has_active_subscription? &&
      current_user.eligible_for_annual_upgrade?
  end
  helper_method :current_user_is_eligible_for_annual_upgrade?

  def current_user_has_access_to?(feature)
    current_user && current_user.has_access_to?(feature)
  end
  helper_method :current_user_has_access_to?

  def current_user_is_admin?
    current_user && (current_user.admin? || masquerading?)
  end

  def masquerading?
    session[:admin_id].present?
  end
  helper_method :masquerading?

  def topics
    Topic.explorable
  end
  helper_method :topics

  def current_team
    current_user.team
  end
  helper_method :current_team

  def onboarding_policy
    OnboardingPolicy.new(current_user)
  end
  helper_method :onboarding_policy

  def github_auth_path(params = {})
    base_path = "/auth/github"

    if params.any?
      "#{base_path}?#{params.to_query}"
    else
      base_path
    end
  end
  helper_method :github_auth_path

  def capture_campaign_params
    session[:campaign_params] ||= {
      utm_campaign: params[:utm_campaign],
      utm_medium: params[:utm_medium],
      utm_source: params[:utm_source],
    }
  end

  def sales_page?
    current_path = request.env["PATH_INFO"]
    [join_path, teams_path].include? current_path
  end

  def determine_layout
    if signed_out? || sales_page?
      "landing"
    else
      "signed_in"
    end
  end
end
