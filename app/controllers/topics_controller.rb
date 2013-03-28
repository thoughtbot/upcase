class TopicsController < ApplicationController
  def index
    expires_in 12.hours, public: true
    @topics = Topic.top
  end

  def show
    expires_in 12.hours, public: true
    @topic = Topic.find_by_slug!(params[:id])
    @articles = @topic.articles.top.published
    @workshops = @topic.workshops.only_active.by_position
    @products = @topic.products.ordered.active
    @related_topics = @topic.related_topics
  end
end
