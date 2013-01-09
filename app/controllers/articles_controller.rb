class ArticlesController < ApplicationController
  def index
    @topic = Topic.find_by_slug!(params[:id])
    @articles = @topic.articles.by_published
    @workshops = @topic.workshops.only_public.by_position
    @products = @topic.products.ordered
  end
end
