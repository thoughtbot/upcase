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

  def current_user_has_active_subscription?
    current_user && current_user.has_active_subscription?
  end
  helper_method :current_user_has_active_subscription?

  def current_user_has_access_to_workshops?
    current_user && current_user.has_access_to_workshops?
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

  def requested_purchaseable
    if product_param
      Product.find(product_param)
    elsif params[:individual_plan_id]
      IndividualPlan.where(sku: params[:individual_plan_id]).first
    elsif params[:team_plan_id]
      TeamPlan.where(sku: params[:team_plan_id]).first
    elsif params[:section_id]
      Section.find(params[:section_id])
    else
      raise "Could not find a purchaseable object from given params: #{params}"
    end
  end

  def in_person_workshops
    Workshop.only_active.by_position.in_person
  end
  helper_method :in_person_workshops

  def online_workshops
    Workshop.only_active.by_position.online
  end
  helper_method :online_workshops

  def books
    Book.active.ordered
  end
  helper_method :books

  def screencasts
    Screencast.active.newest_first
  end
  helper_method :screencasts

  def topics
    Topic.top
  end
  helper_method :topics

  def product_param
    params[:product_id] || params[:screencast_id] || params[:book_id]
  end
end
