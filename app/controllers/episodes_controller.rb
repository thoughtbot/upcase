class EpisodesController < ApplicationController
  def index
    expires_in 1.hour, public: true
    @episodes = Episode.published
    fresh_when(@episodes.first, public: true)
  end

  def show
    @episode = Episode.find_by_number!(params[:id].to_i)
    respond_to do |format|
      format.html
      format.mp3 do
        @episode.increment_downloads
        redirect_to @episode.mp3.url(:id3)
      end
    end
  end
end
