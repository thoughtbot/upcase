class VideosController < ApplicationController
  def index
    @videos = Video.published.recently_published_first

    respond_to do |format|
      format.rss
    end
  end

  def show
    @video = Video.find(params[:id])
    @offering = @video.watchable

    respond_to do |format|
      format.html { render_show_template }
    end
  end

  private

  def render_show_template
    if has_access?
      render "show_licensed"
    elsif @video.preview_wistia_id.present?
      render "show"
    else
      redirect_to @video.watchable
    end
  end

  def has_access?
    can_access_show? || can_access_video_tutorial?
  end

  def can_access_show?
    @video.watchable.is_a?(Show) && current_user_has_access_to?(:shows)
  end

  def can_access_video_tutorial?
    @video.watchable.is_a?(VideoTutorial) &&
      current_user_has_access_to?(:video_tutorials)
  end
end
