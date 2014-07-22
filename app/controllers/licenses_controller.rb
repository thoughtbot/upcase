class LicensesController < ApplicationController
  before_filter :authorize
  before_filter :authorize_subscription

  def create
    licenseable = requested_licenseable
    License.create(user: current_user, licenseable: licenseable)
    redirect_to licenseable, notice: t("licenses.flashes.success")
  end

  def index
    @checkouts = current_user.ordered_licenses
  end

  private

  def authorize_subscription
    unless can_access_licenseable?
      deny_access
    end
  end

  def can_access_licenseable?
    current_user_has_active_subscription? &&
      included_in_current_users_plan?(requested_licenseable)
  end
end
