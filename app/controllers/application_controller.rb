class ApplicationController < ActionController::Base
  include Clearance::Authentication

  helper :all

  protect_from_forgery

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

  def subscription_includes_workshops?
    current_user.subscription.includes_workshops?
  end
  helper_method :subscription_includes_workshops?

  def subscription_includes_mentor?
    current_user.subscription.includes_mentor?
  end
  helper_method :subscription_includes_mentor?

  def current_user_is_admin?
    current_user && current_user.admin?
  end
  helper_method :current_user_is_admin?

  def default_plan
    Plan.default
  end
  helper_method :default_plan

  def find_purchaseable
    if params[:product_id]
      Product.find(params[:product_id])
    elsif params[:plan_id]
      Plan.where(sku: params[:plan_id]).first
    else
      Section.find(params[:section_id])
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
    Product.books.active.ordered
  end
  helper_method :books

  def videos
    Product.videos.active.ordered
  end
  helper_method :videos

  def bytes
    Byte.ordered.published
  end
  helper_method :bytes

  def topics
    Topic.top
  end
  helper_method :topics
end
