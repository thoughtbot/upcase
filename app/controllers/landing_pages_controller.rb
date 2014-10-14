class LandingPagesController < ApplicationController
  layout "landing_pages"

  def show
    render template: "landing_pages/#{params[:id]}"
  end
end
