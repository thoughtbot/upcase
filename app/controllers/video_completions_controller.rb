class VideoCompletionsController < ApplicationController
  def create
    StatusUpdater
      .new(video, current_user)
      .update_state("Complete")

    redirect_to video.watchable
  end

  private

  def video
    Video.find(params[:video_id])
  end
end
