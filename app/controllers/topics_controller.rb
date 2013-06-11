class TopicsController < ApplicationController
  def index
    @topics = Topic.top
  end

  def show
    @topic = Topic.find_by_slug!(params[:id])
  end
end
