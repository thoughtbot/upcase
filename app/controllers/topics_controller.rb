class TopicsController < ApplicationController
  def index
    @topics = Topic.with_colors

    respond_to do |format|
      format.css { render content_type: "text/css" }
    end

    fresh_when(
      etag: @topics.maximum(:updated_at),
      last_modified: @topics.maximum(:updated_at),
      public: true
    )
  end

  def show
    @topic = Topic.find_by_slug!(params[:id])
  end
end
