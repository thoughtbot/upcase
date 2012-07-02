class TopicsController < ApplicationController
  def index
    @books = Product.books.active
    @screencasts = Product.screencasts.active
    @courses = Course.only_public.by_position
    @topics = Topic.all
    @articles = Article.all
  end

  def show
    @topic = Topic.find_by_slug!(topic_slug)
    @books = Product.books.for_topic(@topic).active
    @screencasts = Product.screencasts.for_topic(@topic).active
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
