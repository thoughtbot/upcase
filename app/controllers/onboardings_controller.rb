class OnboardingsController < ApplicationController
  before_action :require_login

  def create
    current_user.update(completed_welcome: true)
    redirect_to practice_path, notice: t("pages.welcome.post-welcome-message")
  end
end
