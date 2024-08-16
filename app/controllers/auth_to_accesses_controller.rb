class AuthToAccessesController < ApplicationController
  def show
    @video = find_video
    save_video_slug
    redirect_to github_auth_with_video_origin_path
  end

  private

  def save_video_slug
    session[:auth_to_access_video_slug] = @video.slug
  end

  def github_auth_with_video_origin_path
    github_auth_path(origin: video_path(@video))
  end

  def find_video
    Video.find(params[:video_id])
  end
end
