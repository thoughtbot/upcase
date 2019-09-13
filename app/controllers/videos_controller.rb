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
      redirect_to video_path(@video.slug), status: :moved_permanently
    else
      render
    end
  end
end
