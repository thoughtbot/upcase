class EpisodesController < ApplicationController
  def index
    @episodes = Episode.published
  end

  def show
    @episode = Episode.find(params[:id])
  end
end
