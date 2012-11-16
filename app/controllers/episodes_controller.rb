class EpisodesController < ApplicationController
  def index
    @episodes = Episode.published
  end

  def show
    @episode = Episode.find(params[:id])
    if topic = @episode.topics.first
      @products = topic.products.ordered
    end
  end
end
