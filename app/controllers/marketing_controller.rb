class MarketingController < ApplicationController
  cache_signed_out_action :show

  layout "marketing"

  def show
    render "pages/landing"
  end
end
