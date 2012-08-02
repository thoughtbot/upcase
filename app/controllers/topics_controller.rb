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

    @books = ResultsDecorator.new(Product.books.active,
      Product.find_books_by_topics(topics))
    @screencasts = ResultsDecorator.new(Product.screencasts.active,
      Product.find_screencasts_by_topics(topics))
    @courses = ResultsDecorator.new(Course.only_public.by_position, 
      Course.find_courses_by_topics(topics))
    @articles = Article.for_topics(topics).by_published.presence || NullArticle.new

    @no_results = @books.visible.blank? && @screencasts.visible.blank? &&
      @courses.visible.blank? && @articles.blank?

    if request.xhr?
      render partial: "topics/filtered_results"
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
