class ArticlesController < ApplicationController
  def index
    @topic = Topic.find_by_slug!(params[:id])
  end
end
