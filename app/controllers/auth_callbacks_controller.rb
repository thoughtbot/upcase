class AuthCallbacksController < ApplicationController
  def create
    sign_in user_from_auth_hash
    track_authed_to_access
    redirect_to_desired_path
    clear_return_to
    clear_auth_to_access_slug
  end

  private

  def track_authed_to_access
    auth_to_access_video.present do |video|
      analytics.track_authed_to_access(
        video_name: video.name,
        watchable_name: video.watchable_name,
      )
    end
  end

  def redirect_to_desired_path
    if auth_to_access_video.present?
      redirect_to(
        url_after_auth,
        notice: t("authenticating.auth_to_access_success"),
      )
    else
      redirect_to url_after_auth
    end
  end

  def url_after_auth
    if originated_from_sign_in_or_sign_up?
      custom_return_path_or_default(practice_path)
    else
      auth_origin
    end
  end

  def user_from_auth_hash
    AuthHashService.new(auth_hash).find_or_create_user_from_auth_hash
  end

  def originated_from_sign_in_or_sign_up?
    auth_origin =~ /^#{sign_in_url}/ || auth_origin =~ /^#{sign_up_url}/
  end

  def custom_return_path_or_default(default_path)
    ReturnPathFinder.new(auth_origin).return_path || default_path
  end

  def auth_to_access_slug
    session[:auth_to_access_video_slug]
  end

  def clear_auth_to_access_slug
    session.delete(:auth_to_access_video_slug)
  end

  def auth_to_access_video
    @_auth_to_access_video ||= Video.find_by(slug: auth_to_access_slug).wrapped
  end

  def auth_hash
    request.env["omniauth.auth"]
  end

  def auth_origin
    session[:return_to] || request.env["omniauth.origin"] || practice_url
  end

  def clear_return_to
    session[:return_to] = nil
  end
end
