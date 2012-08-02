class TopicsController < ApplicationController
  def index
      expires_in 12.hours, public: true

      @featured_topics = Topic.top
      @books = Product.books.active
      @screencasts = Product.screencasts.active
      @courses = Course.only_public.by_position
      @articles = Article.by_published.limit(30)
  end

  def show
      expires_in 12.hours, public: true

      topics = Topic.search(topic_slug)
      @topic = topics.first if topics.size == 1
      @featured_topics = Topic.top

      @books = Product.find_all_books_or_by_topics(topics)
      @screencasts = Product.find_all_screencasts_or_by_topics(topics)
      @courses = Course.find_all_courses_or_by_topics(topics)
      @articles = Article.for_topics(topics).by_published.presence || NullArticle.new

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

  def cache_key
    "#{topic_slug}:#{request.xhr?}"
  end
end
