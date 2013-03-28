class TopicsController < ApplicationController
  def index
    @topics = Topic.top
  end

  def show
    @topic = Topic.find_by_slug!(params[:id])
    @articles = @topic.articles.top.published
    @workshops = @topic.workshops.only_active.by_position
    @products = @topic.products.ordered.active
    @related_topics = @topic.related_topics
  end
end
