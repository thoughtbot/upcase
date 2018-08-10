class VideosController < ApplicationController
  def show
    @video = Video.find(params[:id])
    @watchable = @video.watchable

    respond_to do |format|
      format.html { render_or_redirect }
    end
  end

  private

  def render_or_redirect
    if params[:id] != @video.slug
      redirect_to video_path(@video.slug), status: 301
    else
      render
    end
  end

  def weekly_iteration_video?
    @watchable == Show.the_weekly_iteration
  end
end
