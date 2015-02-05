class TopicsController < ApplicationController
  def index
    respond_to do |format|
      format.css
    end

    fresh_when(
      etag: topics.maximum(:updated_at),
      last_modified: topics.maximum(:updated_at),
      public: true
    )
  end

  def show
    @topic = Topic.find(params[:id])
    respond_to :html
  end

  private

  def topics
    Topic.with_colors
  end

  def assets
    Rails.application.assets
  end
end
