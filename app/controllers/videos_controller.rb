class VideosController < ApplicationController
  def index
    @videos = Video.published.recently_published_first

    respond_to do |format|
      format.rss
    end
  end

  def show
    @video = Video.find(params[:id])
    @offering = Offering.new(@video.watchable, current_user)

    respond_to do |format|
      format.html { render_show_template }
    end
  end

  private

  def render_show_template
    if @offering.user_has_license?
      render "show_licensed"
    elsif @video.preview_wistia_id.present?
      render "show"
    else
      redirect_to @video.watchable
    end
  end
end
