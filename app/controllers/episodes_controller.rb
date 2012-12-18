class EpisodesController < ApplicationController
  def index
    @episodes = Episode.published
    fresh_when(@episodes.first)
  end

  def show
    @episode = Episode.find(params[:id])
    respond_to do |format|
      format.html do
        @related_topics = @episode.topics
        @products = @episode.products.ordered.active
      end
      format.mp3 do
        @episode.increment_downloads
        redirect_to @episode.file
      end
    end
  end
end
