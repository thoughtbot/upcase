class TopicsController < ApplicationController
  def show
    @topic = TopicWithTrails.new(
      topic_slug: params[:id],
      user: current_user
    )
  end
end
