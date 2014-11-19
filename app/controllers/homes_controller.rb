class HomesController < ApplicationController
  layout "landing_pages"

  def show
    if signed_in?
      redirect_to practice_path
    else
      @community_size = User.subscriber_count
      render template: "landing_pages/watch-one-do-one-teach-one"
    end
  end
end
