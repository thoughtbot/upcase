class TimelinesController < ApplicationController
  before_filter :authorize

  def show
    @completion_weeks = current_user.completions_grouped_by_week
  end
end
