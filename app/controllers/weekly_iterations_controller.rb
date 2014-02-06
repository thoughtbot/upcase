class WeeklyIterationsController < ApplicationController
  layout 'landing_pages'

  def show
    @show = Show.the_weekly_iteration
    @plan = IndividualPlan.basic

    if signed_in?
      redirect_to @show
    end
  end
end
