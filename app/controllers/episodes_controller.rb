class EpisodesController < ApplicationController
  def index
    @episodes = Episode.published
  end

  def show
    @episode = Episode.find(params[:id])
    @related_topics = @episode.topics
    @products = @episode.products.ordered
  end
end
