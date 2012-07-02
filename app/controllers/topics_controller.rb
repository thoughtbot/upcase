class TopicsController < ApplicationController
  def index
    @books = Product.active.where("product_type LIKE '%book%'")
    @screencasts = Product.active.where("product_type LIKE '%screencast%'")
    @courses = Course.only_public.by_position
    @topics = Topic.all
    @articles = Article.all
  end

  def show
    @topic = Topic.find_by_slug!(topic_slug)
    @books = Product.active.where("product_type LIKE '%book%'")
    @screencasts = Product.active.where("product_type LIKE '%screencast%'")
    @courses = Course.only_public.by_position
    @topics = Topic.all
    @articles = @topic.articles
    render :index
  end

  private

  def topic_slug
    params[:id]
  end
end
