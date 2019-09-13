class MarketingController < ApplicationController
  layout "marketing"

  def show
    render "pages/landing"
  end
end
