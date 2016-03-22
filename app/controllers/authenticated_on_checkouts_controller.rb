class AuthenticatedOnCheckoutsController < ApplicationController
  def show
    set_authenticated_on_checkout_page_flag
    redirect_to github_auth_with_checkout_origin_path
  end

  private

  def set_authenticated_on_checkout_page_flag
    session[:authenticated_on_checkout] = true
  end

  def github_auth_with_checkout_origin_path
    github_auth_path(origin: new_checkout_path(plan: plan))
  end

  def plan
    Plan.find_by!(sku: params[:plan])
  end
end
