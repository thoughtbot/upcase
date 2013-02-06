class ArticlesController < ApplicationController
  def index
    @topic = Topic.find_by_slug!(params[:id])
    @articles = @topic.articles.by_published
    @workshops = @topic.workshops.only_public.by_position
    @products = @topic.products.ordered
  end

  def show
    @article = Article.find(params[:id])
    if @article.tumblr_url.present?
      redirect_to @article.tumblr_url, status: :moved_permanently
    end
    @related_topics = @article.topics
    @products = @article.products.ordered.active
    @workshops = @article.workshops.only_public.by_position
  end
end
