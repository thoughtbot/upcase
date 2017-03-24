class MarketingController < ApplicationController
  layout 'marketing'

  def index
    @language = params[:language]
  end
end
