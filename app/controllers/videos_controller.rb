class VideosController < ApplicationController
  def show
    @video = Video.find(params[:id])

    if @license = current_user_license_of(@video.watchable)
      render "show_licensed"
    elsif @video.preview_wistia_id.present?
      render "show"
    else
      redirect_to @video.watchable
    end
  end
end
