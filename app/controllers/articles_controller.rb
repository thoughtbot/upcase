class ArticlesController < ApplicationController
  def index
    @topic = Topic.find_by_slug!(params[:id])
    @articles = @topic.articles.by_published
    @workshops = @topic.workshops.only_public.by_position
    @products = @topic.products.ordered
  end

  def show
    @article = Article.find(params[:id])
    if @article.local?
      if current_user_has_active_subscription?
        @related_topics = @article.topics
        @products = @article.products.ordered.active
        @workshops = @article.workshops.only_public.by_position
      else
        redirect_to subscription_product, notice: t('shared.subscriptions.protected_content')
      end
    else
      redirect_to @article.external_url, status: :moved_permanently
    end
  end
end
