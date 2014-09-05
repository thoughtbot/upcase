class VideoTutorialsController < ApplicationController
  def show
    @offering = Offering.new(video_tutorial, current_user)

    if @offering.user_has_license?
      render polymorphic_licenseable_template
    end
  end

  private

  def video_tutorial
    VideoTutorial.friendly.find(params[:id])
  end
end
