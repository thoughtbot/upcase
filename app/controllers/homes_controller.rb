class HomesController < ApplicationController
  layout "landing_pages"

  def show
    if signed_in?
      redirect_user_to_dashboard
    else
      @community_size = User.subscriber_count
      render template: "landing_pages/watch-one-do-one-teach-one"
    end
  end

  private

  def redirect_user_to_dashboard
    if show_exercises?
      redirect_to practice_path
    else
      redirect_to Show.the_weekly_iteration
    end
  end

  def show_exercises?
    current_user.subscription.nil? || current_user.has_access_to?(:exercises)
  end
end
