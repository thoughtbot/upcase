class TopicsController < ApplicationController
  def index
    @topics = Topic.all
  end

  def show
    @topic = Topic.find_by_slug!(topic_slug)
  end

  private

  def topic_slug
    params[:id]
  end
end
