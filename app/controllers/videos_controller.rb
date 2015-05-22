class VideosController < ApplicationController
  def index
    @videos = Video.published.recently_published_first

    respond_to do |format|
      format.rss
    end
  end

  def show
    @video = Video.find(params[:id])
    @watchable = @video.watchable

    respond_to do |format|
      format.html { render_show_template }
    end
  end

  private

  def render_show_template
    if has_access?
      render "show_for_subscribers"
    elsif @video.preview_wistia_id.present?
      render "show_for_visitors"
    else
      redirect_to @video.watchable
    end
  end

  def has_access?
    signed_in? &&
      current_user.plan.present? &&
      @video.included_in_plan?(current_user.plan)
  end
end
