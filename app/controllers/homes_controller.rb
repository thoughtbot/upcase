class HomesController < ApplicationController
  layout "landing_pages"

  def show
    if signed_in?
      redirect_to dashboard_path
    else
      @community_size = User.with_active_subscription.count
      render template: "landing_pages/watch-one-do-one-teach-one"
    end
  end
end
