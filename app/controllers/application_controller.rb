class ApplicationController < ActionController::Base
  include Clearance::Authentication

  cattr_accessor :km_http_client

  helper :all

  protect_from_forgery

  protected

  def must_be_admin
    unless current_user && current_user.admin?
      flash[:error] = 'You do not have permission to view that page.'
      redirect_to root_url
    end
  end

  def km_http_client
    @@km_http_client.new(KISSMETRICS_API_KEY)
  end

  def current_user_has_active_subscription?
    current_user && current_user.has_active_subscription?
  end
  helper_method :current_user_has_active_subscription?

  def current_user_is_admin?
    current_user && current_user.admin?
  end
  helper_method :current_user_is_admin?

  def subscription_product
    Product.subscriptions.first
  end
  helper_method :subscription_product

  def find_purchaseable
    if params[:product_id]
      Product.find(params[:product_id])
    else
      Section.find(params[:section_id])
    end
  end

  def in_person_workshops
    Workshop.only_public.by_position.in_person
  end
  helper_method :in_person_workshops

  def online_workshops
    Workshop.only_public.by_position.online
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
    Article.local.top.published
  end
  helper_method :bytes

  def topics
    Topic.top
  end
  helper_method :topics
end
