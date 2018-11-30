class ShowsController < ApplicationController
  def show
    @show = find_show
    @video_listing = video_listing_for_user

    respond_to do |format|
      format.html
      format.rss
    end
  end

  private

  def sorted_published_videos
    find_show.published_videos.recently_published_first.page(page_param)
  end

  def page_param
    params[:page].to_i
  end

  def find_show
    Show.friendly.find(params[:id])
  end

  def video_listing_for_user
    VideoListing.new(sorted_published_videos, current_user)
  end
end
