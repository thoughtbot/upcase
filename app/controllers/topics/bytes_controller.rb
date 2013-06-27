class Topics::BytesController < ApplicationController
  def index
    @topic = Topic.find_by_slug!(params[:topic_id])
  end
end
