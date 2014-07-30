class VideosController < ApplicationController
  def show
    @video = Video.find(params[:id])
    @offering = Offering.new(@video.watchable, current_user)

    if @offering.user_has_license?
      render "show_licensed"
    elsif @video.preview_wistia_id.present?
      render "show"
    else
      redirect_to @video.watchable
    end
  end
end
