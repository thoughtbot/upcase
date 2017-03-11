class MarketingController < ApplicationController
  layout 'marketing'

  def welcome
    @language = params[:language]

    return unless params[:language_name]
    flash[:notice] = 'Thanks for signing up. We will be in touch!'
  end
end
