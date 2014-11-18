class TwitterPlayerCardsController < ApplicationController
  layout false

  def show
    response.headers.delete("X-Frame-Options")
    @video = Video.find(params[:video_id])
  end
end
