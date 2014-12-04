class ResourcesController < ApplicationController
  def index
    @topic = TopicWithTrails.new(
      topic_slug: params[:topic_id],
      user: current_user
    )
  end
end
