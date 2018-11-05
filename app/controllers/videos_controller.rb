class VideosController < ApplicationController
  cache_signed_out_action :show

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
end
