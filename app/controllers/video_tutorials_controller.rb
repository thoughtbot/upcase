class VideoTutorialsController < ApplicationController
  def show
    @video_tutorial = VideoTutorial.friendly.find(params[:id])

    if current_user_has_access_to?(:trails)
      render "show_subscribed"
    end
  end
end
