class ShowsController < ApplicationController
  layout "landing_pages"

  def show
    @show = Show.friendly.find(params[:id])
    @plan = Plan.basic

    respond_to do |format|
      format.html do
        if current_user_has_access_to?(:shows)
          render "show_subscribed", layout: "application"
        else
          render "show_for_visitors"
        end
      end
      format.rss
    end
  end
end
