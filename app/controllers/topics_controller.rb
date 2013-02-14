class TopicsController < ApplicationController
  def index
    expires_in 12.hours, public: true
    @topics = Topic.top
    @promoted_left = promoted_item('left')
    @promoted_middle = promoted_item('middle')
    @promoted_right = promoted_item('right')
  end

  def show
    expires_in 12.hours, public: true
    @topic = Topic.find_by_slug!(params[:id])
    @articles = @topic.articles.top.published
    @workshops = @topic.workshops.only_public.by_position
    @products = @topic.products.ordered.active
    @related_topics = @topic.related_topics
  end

  private

  def promoted_item(location)
    Workshop.promoted(location) || Product.promoted(location)
  end
end
