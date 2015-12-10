module AppleTv
  class WeeklyIterationsController < ApplicationController
    def index
      @show = ShowListing.new(
        Show.the_weekly_iteration,
        current_user,
      )
    end

    def show
    end
  end
end
