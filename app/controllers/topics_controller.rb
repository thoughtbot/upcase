class TopicsController < ApplicationController
  def index
    fresh_when(
      etag: topics.maximum(:updated_at),
      last_modified: topics.maximum(:updated_at),
      public: true
    )
  end

  def show
    @topic = Topic.find_by_slug!(params[:id])
  end

  private

  def topics
    Topic.with_colors
  end

  def assets
    Rails.application.assets
  end
end
