class MarketingController < ApplicationController
  layout "marketing"

  def show
    if signed_in?
      redirect_to onboarding_policy.root_path
    else
      @language = params[:language]

      return unless params[:language_name]
      flash[:notice] = t("marketing.show.language_flash")
    end
  end
end
