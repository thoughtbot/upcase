class ApplicationController < ActionController::Base
  include Clearance::Controller

  helper :all

  protect_from_forgery with: :exception

  before_filter :capture_campaign_params

  protected

  def must_be_admin
    unless current_user_is_admin?
      flash[:error] = 'You do not have permission to view that page.'
      redirect_to root_url
    end
  end

  def must_be_team_owner
    authorize
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

  def current_user_has_monthly_subscription?
    current_user_has_active_subscription? &&
      current_user.has_monthly_subscription?
  end
  helper_method :current_user_has_monthly_subscription?

  def current_user_has_access_to_video_tutorials?
    current_user && current_user.has_access_to?(:video_tutorials)
  end
  helper_method :current_user_has_access_to_video_tutorials?

  def subscription_includes_mentor?
    current_user.has_subscription_with_mentor?
  end
  helper_method :subscription_includes_mentor?

  def current_user_is_admin?
    current_user && (current_user.admin? || masquerading?)
  end

  def masquerading?
    session[:admin_id].present?
  end
  helper_method :masquerading?

  def requested_licenseable
    PolymorphicFinder.
      finding(VideoTutorial, :slug, [:video_tutorial_id]).
      finding(
        Product,
        :slug,
        [:product_id, :show_id, :repository_id]
      ).
      find(params)
  end

  def requested_subscribeable
    Plan.where(sku: params[:plan]).first
  end

  def included_in_current_users_plan?(licenseable)
    licenseable.included_in_plan?(current_user.plan)
  end
  helper_method :included_in_current_users_plan?

  def topics
    Topic.top
  end
  helper_method :topics

  def current_user_license_of(licenseable)
    if signed_in?
      licenseable.license_for(current_user)
    end
  end
  helper_method :current_user_license_of

  def polymorphic_licenseable_template
    "#{@offering.licenseable.class.name.tableize}/show_licensed"
  end

  def current_team
    current_user.team
  end
  helper_method :current_team

  def capture_campaign_params
    session[:campaign_params] ||= {
      utm_campaign: params[:utm_campaign],
      utm_medium: params[:utm_medium],
      utm_source: params[:utm_source],
    }
  end
end
