# All Administrate controllers inherit from this `ApplicationController`,
# making it the ideal place to put authentication logic or other
# before_filters.
#
# If you want to add pagination or other controller-level concerns,
# you're free to overwrite the RESTful controller actions.
class Admin::ApplicationController < Administrate::ApplicationController
  include Clearance::Controller
  before_filter :authenticate_admin

  def authenticate_admin
    must_be_admin
  end

  def index
    super

    flash.now[:alert] =
      "For performance, Administrate limits the index page to show 20 items.
      Customize this action to update/remove the limit,
      or implement the pagination library of your choice."
    @resources = @resources.limit(20)
  end

  use_vanity :current_user

  protected

  def must_be_admin
    unless current_user_is_admin?
      flash[:error] = 'You do not have permission to view that page.'
      redirect_to root_url
    end
  end

  def current_user_is_admin?
    current_user && (current_user.admin? || masquerading?)
  end

  def masquerading?
    session[:admin_id].present?
  end
end
