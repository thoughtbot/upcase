class VideosController < ApplicationController
  def show
    @video = Video.find(params[:id])
    @watchable = @video.watchable

    respond_to do |format|
      format.html { render_or_redirect }
    end
  end

  private

  def render_or_redirect
    if current_user_has_access_to?(@video) || weekly_iteration_video?
      render
    else
      redirect_to sign_in_path, notice: I18n.t("authenticating.login_required")
    end
  end

  def weekly_iteration_video?
    @watchable == Show.the_weekly_iteration
  end
end
