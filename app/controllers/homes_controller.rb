class HomesController < ApplicationController
  def show
    if signed_in?
      redirect_user_to_dashboard
    else
      redirect_to join_path
    end
  end

  private

  def redirect_user_to_dashboard
    if show_trails?
      redirect_to practice_path
    else
      redirect_to Show.the_weekly_iteration
    end
  end

  def show_trails?
    current_user.subscription.nil? || current_user.has_access_to?(:trails)
  end
end
