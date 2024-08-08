class TopicsController < ApplicationController
  def show
    @topic = TopicWithTrails.new(
      topic_slug: params[:id],
      user: current_user
    )
    @video_listing = VideoListing.new(
      @topic.weekly_iteration_videos,
      current_user
    )
  end
end
