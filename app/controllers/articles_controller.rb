class ArticlesController < ApplicationController
  def index
    @topic = Topic.find_by_slug!(params[:id])
    @articles = @topic.articles.ordered.published
    @workshops = @topic.workshops.only_active.by_position
    @products = @topic.products.ordered
  end

  def show
    @article = Article.find(params[:id])
    if @article.local?
      if current_user_has_active_subscription? || current_user_is_admin?
        @related_topics = @article.topics
        @products = @article.products.ordered.active
        @workshops = @article.workshops.only_active.by_position
        if !@article.published? && !current_user_is_admin?
          deny_access
        end
      else
        redirect_to subscription_product, notice: t('shared.subscriptions.protected_content')
      end
    else
      redirect_to @article.external_url, status: :moved_permanently
    end
  end

  private

  def url_after_denied_access_when_signed_in
    sign_in_path
  end
end
