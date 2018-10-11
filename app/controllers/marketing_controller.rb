class MarketingController < ApplicationController
  cache_signed_out_action :show

  layout "marketing"

  def show
    if signed_in?
      redirect_to onboarding_policy.root_path
    else
      render "pages/landing"
    end
  end
end
