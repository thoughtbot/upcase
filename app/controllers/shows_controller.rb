class ShowsController < ApplicationController
  def show
    @show = ShowListing.new(
      Show.friendly.find(params[:id]),
      current_user,
    )

    respond_to do |format|
      format.html
      format.rss
    end
  end

  private

  def has_access_to_shows?
    current_user_has_access_to?(Show)
  end
  helper_method :has_access_to_shows?
end
