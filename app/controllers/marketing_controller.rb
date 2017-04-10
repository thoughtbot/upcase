class MarketingController < ApplicationController
  layout "marketing"

  def show
    if signed_in?
      redirect_to onboarding_policy.root_path
    else
      @language = params[:language]
    end
  end
end
