class DownloadsController < ApplicationController
  before_action :require_login

  def show
    track_downloaded
    redirect_to video.download_url(download_type)
  end

  private

  def video
    Video.find_by(wistia_id: params[:clip_id])
  end

  def download_type
    params[:download_type]
  end

  def track_downloaded
    analytics.track_downloaded(
      name: video.name,
      watchable_name: video.watchable_name,
      download_type: download_type,
    )
  end
end
