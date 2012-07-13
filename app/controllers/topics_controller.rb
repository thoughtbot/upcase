class TopicsController < ApplicationController
  def index
    @featured_topics = Topic.top
    @books = Product.books.active
    @screencasts = Product.screencasts.active
    @courses = Course.only_public.by_position
    @articles = Article.order("published_on desc").limit(30)
  end

  def show
    @featured_topics = Topic.top
    topics = Topic.search(topic_slug)
    @books = []
    @screencasts = []
    @courses = []
    @articles = []
    topics.each do |topic|
      @books.push *Product.books.for_topic(topic).active
      @screencasts.push *Product.screencasts.for_topic(topic).active
      @courses.push *Course.for_topic(topic).only_public.by_position
      @articles.push *topic.articles
    end
    @topic = topics.first if topics.size == 1

    if request.xhr?
      render partial: "topics/results"
    else
      render :index
    end
  end

  private

  def topic_slug
    params[:id]
  end
end
