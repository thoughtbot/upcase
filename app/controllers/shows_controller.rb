class ShowsController < ApplicationController
  def show
    @show = find_show
    @video_listing = VideoListing.new(sorted_published_videos, current_user)

    respond_to do |format|
      format.html
      format.rss
    end
  end

  private

  def sorted_published_videos
    find_show.published_videos.recently_published_first
  end

  def find_show
    Show.friendly.find(params[:id])
  end

  def has_access_to_shows?
    current_user_has_access_to?(Show)
  end
  helper_method :has_access_to_shows?
end
