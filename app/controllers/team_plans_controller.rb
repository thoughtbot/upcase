class TeamPlansController < ApplicationController
  def index
    @plans = TeamPlan.featured.ordered
  end
end
