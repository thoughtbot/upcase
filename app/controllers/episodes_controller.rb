class EpisodesController < ApplicationController
  def index
    expires_in 1.hour, public: true
    @show = current_show
    fresh_when(@show.episodes.published.first, public: true)
  end

  def show
    @episode = current_show.episodes.published.find_by_number!(params[:id].to_i)
    respond_to do |format|
      format.html
      format.mp3 do
        @episode.increment_downloads
        redirect_to @episode.mp3.url(:id3)
      end
    end
  end

  private

  def current_show
    Show.find_by_slug!(params[:show_id])
  end
end
