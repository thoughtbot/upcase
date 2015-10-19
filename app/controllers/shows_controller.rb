class ShowsController < ApplicationController
  def show
    @show = ShowListing.new(
      Show.friendly.find(params[:id]),
      current_user,
    )

    respond_to do |format|
      format.html do
        if current_user_has_access_to?(Show)
          render "show_subscribed"
        else
          render "show_for_visitors"
        end
      end
      format.rss
    end
  end
end
