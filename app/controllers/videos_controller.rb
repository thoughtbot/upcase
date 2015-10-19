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
    if current_user_has_access_to?(@video)
      render "show_for_subscribers"
    else
      render "show_for_visitors"
    end
  end
end
