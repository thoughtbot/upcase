class ApplicationController < ActionController::Base
  include Clearance::Controller

  helper :all

  protect_from_forgery with: :exception

  protected

  def must_be_admin
    unless current_user && current_user.admin?
      flash[:error] = 'You do not have permission to view that page.'
      redirect_to root_url
    end
  end

  def must_be_team_member
    authorize
    if signed_in? && current_user.team.blank?
      deny_access('You must be a member of a team to access that resource.')
    end
  end

  def current_user_has_active_subscription?
    current_user && current_user.has_active_subscription?
  end
  helper_method :current_user_has_active_subscription?

  def current_user_has_access_to_workshops?
    current_user && current_user.has_access_to?(:workshops)
  end
  helper_method :current_user_has_access_to_workshops?

  def subscription_includes_mentor?
    current_user.has_subscription_with_mentor?
  end
  helper_method :subscription_includes_mentor?

  def current_user_is_admin?
    current_user && current_user.admin?
  end
  helper_method :current_user_is_admin?

  def requested_licenseable
    PolymorphicFinder.
      finding(Workshop, :id, [:workshop_id]).
      finding(Product, :id, [:product_id, :screencast_id, :book_id, :show_id]).
      find(params)
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
    "#{@offering.to_partial_path}_purchase_show"
  end
end
